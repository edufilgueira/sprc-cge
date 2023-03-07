class Answer < ApplicationRecord
  # Constants

  APPROVED_STATUSES = [
    :cge_approved, :sectoral_approved, :subnet_approved
  ]

  VISIBLE_TO_USER_STATUSES = [
    :cge_approved, :user_evaluated, :call_center_approved, :sectoral_approved
  ]

  APPROVED_STATUSES_TO_FINALIZE_TICKET = [
    :cge_approved, :sectoral_approved, :subnet_approved, :call_center_approved, :user_evaluated
  ]

  SCOPES_ALLOWING_FINAL_ANSWER = [:sectoral, :cge, :call_center, :subnet]

  POSITIONING_SCOPES = [:department, :subnet_department]

  VISIBLE_TO_OPERATOR_STATUSES = [
    :sectoral_rejected,
    :cge_rejected,
    :subnet_rejected,
    :subnet_approved
  ] + VISIBLE_TO_USER_STATUSES

  OPERATOR_PERMITTED_PARAMS = [
    :user,
    :description,
    :ticket_id,
    :answer_scope,
    :answer_type,
    :status,
    :classification,
    :certificate,

    attachments_attributes: [
      :document
    ]
  ]

  ACTIVE_STATUSES = [
    :awaiting,
    :sectoral_approved,
    :cge_approved,
    :user_evaluated,
    :call_center_approved,
    :subnet_approved
  ]

  # Setup

  acts_as_paranoid

  attachment :certificate

  # Callbacks

  before_create :set_original_description
  before_create :set_sectoral_deadline

  # Associations

  belongs_to :ticket
  belongs_to :user

  has_one :evaluation
  has_one :ticket_department_email

  has_many :ticket_logs, as: :resource
  has_many :attachments, as: :attachmentable, dependent: :destroy
  # XXX simulando relação de `has_one :ticket_log` original, do Ticket exato onde a resposta foi feita.
  # Isso se faz necessário pois, caso criemos uma resposta em um Ticket-filho, "duplicamos" um
  # TicketLog no Ticket-pai para que seja possível exibir a resposta no Ticket-pai.
  def ticket_log; ticket_logs.find_by(ticket: ticket) end

  # Delegations

  delegate :as_author, to: :user, allow_nil: true
  delegate :average, to: :evaluation, prefix: true, allow_nil: true
  delegate :department, to: :user, prefix: true, allow_nil: true
  delegate :sic?, to: :ticket, prefix: true, allow_nil: true


  # Enums

  enum answer_scope: [:department, :sectoral, :cge, :call_center, :subnet, :subnet_department]
  enum answer_type: [:partial, :final]

  enum status: {
    awaiting: 0,
    sectoral_rejected: 1,
    sectoral_approved: 2,
    cge_rejected: 3,
    cge_approved: 4,
    user_evaluated: 5,
    call_center_approved: 7,
    subnet_rejected: 8,
    subnet_approved: 9,
    # awaiting_cge: 10 @see https://github.com/caiena/sprc/issues/1671
  }

  enum classification: Ticket::ANSWER_CLASSIFICATION_MAP

  # Attachments

  accepts_attachments_for :attachments, append: true

  # Nested

  accepts_nested_attributes_for :attachments,
    reject_if: :all_blank, allow_destroy: true

  # Attributes

  attr_accessor :justification, :department_id

  # Validations

  ## Presence

  validates :description,
    :ticket,
    :answer_scope,
    :answer_type,
    :status,
    presence: true

  validates :certificate,
    presence: true,
    if: -> { classification_rejected_answer? && sectoral?}


  validates :classification,
    presence: true,
    if: -> { cge? || sectoral? || subnet? }

  # Public

  ## Class methods

  ### Scopes

  def self.sorted
    order(:created_at)
  end

  def self.approved
    where(status: APPROVED_STATUSES)
  end

  def self.approved_for_citizen
    where(status: VISIBLE_TO_USER_STATUSES)
  end

  def self.by_department(department_id)
    positioning_scope
      .left_joins(:user, ticket_department_email: :ticket_department)
      .where("users.department_id = ? OR ticket_departments.department_id = ?", department_id, department_id)
  end

  def self.active
    where(status: ACTIVE_STATUSES)
  end

  def self.positioning_scope
    where(answer_scope: Answer::POSITIONING_SCOPES)
  end

  def self.allowing_final_answer_scope
    where(answer_scope: Answer::SCOPES_ALLOWING_FINAL_ANSWER)
  end

  def self.by_version(version)
    where(version: version)
  end

  ## Instance methods

  ### Helpers
  #

  def approved_for_user?
    cge_approved? || call_center_approved?
  end

  def positioning?
    department? || subnet_department?
  end

  def answer_type_str
    Answer.human_attribute_name("answer_type.#{answer_type}")
  end

  def status_str
    Answer.human_attribute_name("status.#{ticket.ticket_type}.#{status}")
  end

  def classification_str
    return "" unless classification.present?

    Answer.human_attribute_name("classification.#{classification}")
  end

  def modified_description?
    original_description != description
  end

  def rejected_answer?
    status.to_s.match(/rejected/)
  end

  private

  def set_original_description
    self.original_description = description
  end

  def set_sectoral_deadline

    partial_answer = Answer.where(
      ticket_id: ticket_id, version: version, answer_type: :partial,
      answer_scope: SCOPES_ALLOWING_FINAL_ANSWER, status: :cge_approved
    ).order(:created_at).first

    self.sectoral_deadline =
      if partial_answer.present? && partial_answer.sectoral_deadline.present?
        partial_answer.sectoral_deadline
      else
        positioning? ? nil : ticket.deadline
      end
  end

  def classification_rejected_answer?
    classification.to_s.match(/rejected/) && !ticket.appeals?
  end

end
