#
# Representa a relação das Unidades internas de um órgão com o chamado associado.
#

class TicketDepartment < ApplicationRecord
  include ::ProtectedAttachment
  include NestedUniqueness

  # Setup

  acts_as_paranoid

  # Associations

  belongs_to :ticket
  belongs_to :department
  belongs_to :user

  has_many :ticket_department_emails, inverse_of: :ticket_department, dependent: :destroy
  has_many :ticket_department_sub_departments, inverse_of: :ticket_department, dependent: :destroy
  has_many :ticket_protect_attachments, as: :resource, dependent: :destroy


  # Nested

  accepts_nested_attributes_for :ticket_department_emails, allow_destroy: true
  accepts_nested_attributes_for :ticket_department_sub_departments, allow_destroy: true


  # Attributes

  attr_accessor :justification
  attr_accessor :protected_attachment_ids
  


  # Enums

  enum answer: [:not_answered, :answered]

  # Delegations

  delegate :name, :acronym, to: :department, prefix: true
  delegate :organ_acronym, :reopened_at, :appeals_at, to: :ticket
  delegate :reopened_at, :appeals_at, to: :ticket, prefix: true
  delegate :subnet_acronym, to: :department

  # Validations

  ## Presence

  validates :ticket,
    :department,
    :description,
    presence: true

  #
  # Quando o campo justification está presente no form ele é
  # preenchido com '' ao invés de nil, assim é possível validar sua presença
  #
  validates :justification,
    presence: true,
    unless: -> { justification.nil? }


  ## Uniqueness

  validates :department_id,
    uniqueness: { scope: :ticket_id }

  validates_uniqueness :ticket_department_sub_departments, { attribute: :sub_department_id, case_sensitive: false, message: :taken }

  # Instance methods

  ## Helpers

  def title
    prefix = ''

    if subnet_acronym.present?
      prefix = "#{subnet_acronym} / "
    end

    "[#{organ_acronym}] #{prefix}#{department_name}"
  end

  def title_for_sectoral
    deadline_label =
      if self.deadline.present?
        I18n.t('ticket.deadline', count: self.deadline)
      else
        I18n.t('ticket_department.deadline.undefined')
      end

    "#{department_acronym} (#{deadline_label})"
  end

  def subnet?
    ticket.present? && ticket.subnet?
  end

  def unit
    department
  end

  def deadline_ends_at_range
    Date.today..self.ticket.deadline_ends_at
  end

  # data limite para que a area interna responda o chamado
  def response_deadline
    deadline_ends_at ? deadline_ends_at : ticket.deadline_ends_at
  end

  # número de dias restantes para a area interna responder o chamado
  def remaining_days_to_deadline
    deadline ? deadline : ticket.deadline
  end

  # justificativa dada ao encaminhar para a area interna
  def forward_justification
    forward_ticket_log.description
  end

  def created_by
    user
  end

  private

  def forward_ticket_log
    ticket.ticket_logs.forward.find_by(resource_type: :Department, resource_id: department_id)
  end
end
