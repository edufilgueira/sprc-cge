#
# Representa um pedido de prorrogação de prazo de um chamado
#

class Extension < ApplicationRecord

  # Setup

  acts_as_paranoid

  #  Enums

  enum status: [:in_progress, :approved, :rejected, :cancelled]

  # Associations

  belongs_to :ticket
  belongs_to :ticket_department

  has_one :organ, through: :ticket

  has_many :ticket_logs, as: :resource, dependent: :destroy
  has_many :extension_users, dependent: :destroy

  # Delegations

  delegate :parent_protocol, to: :ticket, prefix: true
  delegate :acronym, to: :organ, prefix: true
  delegate :title, to: :ticket_department, prefix: :department

  # Attributes

  attr_accessor :justification

  # Validations

  ## Presence

  validates :description,
    :ticket,
    :status,
    presence: true

  ## Uniqueness

  validates_uniqueness_of :ticket_id,
    scope: [:ticket_id, :status],
    if: -> { self.in_progress? }

  #  Callbacks

  after_save :update_ticket_extended, if: :approved?


  # Public

  ## Instance methods

  ### Scopes

  def extend_deadline
    return unless approved?

    tickets_extended.each do |resource|
      total_days_count = weekday(resource)

      resource.deadline_ends_at = resource_initial_date(resource) + total_days_count.days
      resource.deadline = calculate_deadline(resource)

      resource.save

      extra_days_to_answer = Holiday.next_weekday(Ticket::response_extension_days)

      next unless extra_days_to_answer.positive? && resource.try(:answers).present?

      resource.answers.each do |answer|
        answer.sectoral_deadline += extra_days_to_answer if answer.sectoral_deadline.present?
        answer.deadline += extra_days_to_answer if answer.deadline.present?
        answer.save if answer.sectoral_deadline.present? || answer.deadline.present?
      end
    end
  end

  ### Helpers

  def status_str
    Extension.human_attribute_name("status.#{status}")
  end

  def external_token_url
    Rails.application.routes.url_helpers.url_for(controller: '/extensions', action: 'edit', id: token)
  end

  def requester_name
    ticket_department.present? ? department_title : organ_acronym
  end

  def weekday(resource)
    Holiday.next_weekday(response_extension, resource_initial_date(resource))
  end

  private

  def tickets_extended
    [ticket_parent] + all_children + all_tickets_departments
  end

  def all_children
    return [] if ticket_parent.no_children?
    ticket_parent.tickets
  end

  def all_tickets_departments
    return [] unless all_children.present?
    TicketDepartment.where(ticket: all_children)
  end

  def ticket_parent
    ticket.parent || ticket
  end

  def response_extension
    Ticket.response_extension(ticket.ticket_type)
  end

  def update_ticket_extended
    parent = self.ticket.parent || self.ticket

    solicitation_data = { 1 => :extended, 2 => :extended_second_time }

    extension_column = solicitation_data[self.solicitation]

    parent.update_attribute(extension_column, true)
    parent.tickets.each { |t| t.update_attribute(extension_column, true) }
  end

  def resource_initial_date(resource)
    case resource.class.to_s
    when 'Ticket'
      if resource.extended_second_time && resource.deadline_ends_at
        resource.deadline_ends_at
      else
        resource.appeals_at || resource.reopened_at || resource.confirmed_at
      end
    when 'TicketDepartment'
      if resource.ticket.extended_second_time && (resource.deadline_ends_at || resource.ticket.deadline_ends_at)
        resource.deadline_ends_at || resource.ticket.deadline_ends_at
      else
        resource.ticket_appeals_at || resource.ticket_reopened_at || resource.created_at
      end
    end
  end

  def calculate_deadline(resource)
    (resource.deadline_ends_at - Date.today).to_i
  end

end
