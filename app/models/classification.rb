class Classification < ApplicationRecord

  # Setup

  acts_as_paranoid

  # Consts

  NULL_ATTRIBUTES_WHEN_OTHER_ORGANS = [
    :topic,
    :subtopic,
    :department,
    :sub_department,
    :budget_program,
    :service_type
  ]

  # Callbacks

  before_validation :update_attributes_when_other_organs, if: :other_organs?

  after_commit :update_ticket

  # Associations

  belongs_to :ticket
  belongs_to :topic
  belongs_to :subtopic
  belongs_to :department
  belongs_to :sub_department
  belongs_to :budget_program
  belongs_to :service_type

  # Delegations

  delegate :name, to: :topic, prefix: true, allow_nil: true
  delegate :name, to: :subtopic, prefix: true, allow_nil: true
  delegate :name, to: :department, prefix: true, allow_nil: true
  delegate :name, to: :sub_department, prefix: true, allow_nil: true
  delegate :name, to: :budget_program, prefix: true, allow_nil: true
  delegate :name, to: :service_type, prefix: true, allow_nil: true

  # Validations

  ## Presence

  validates :ticket,
    :topic,
    :budget_program,
    :service_type,
    presence: true

  validates :department,
    presence: true,
    unless: :other_organs?

  validates :sub_department,
    presence: true,
    if: :department_has_sub_departments?

  validates :subtopic,
    presence: true,
    if: :topic_has_subtopics?,
    unless: :other_organs?

  validates_uniqueness_of :ticket_id

  # Scopes

  def self.sorted
    order(:ticket)
  end


  # Instance methods

  def update_attributes_when_other_organs
    self.topic = Topic.other_organs
    self.subtopic = Subtopic.other_organs
    self.budget_program = BudgetProgram.other_organs
    self.service_type = ServiceType.other_organs
    self.department = nil
    self.sub_department = nil
  end


  # privates

  private

  def update_ticket
    ticket.classified = !deleted?
    ticket.unknown_classification = !ticket.classified?
    ticket.public_ticket = !other_organs if ticket.child?
    if other_organs?
      classification_for_answer = ticket.sic? ? 'sic_not_attended_other_organs' : 'other_organs'
      ticket.answer_classification = classification_for_answer
    end

    ticket.save
  end

  def topic_has_subtopics?
    topic.present? && topic.subtopics.enabled.present?
  end

  def department_has_sub_departments?
    department.present? && department.sub_departments.enabled.present?
  end

  def ticket_user
    ticket.updated_by || ticket.created_by
  end
end
