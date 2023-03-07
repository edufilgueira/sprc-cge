class TicketDepartmentSubDepartment < ApplicationRecord
    # Setup

  acts_as_paranoid

  # Associations

  belongs_to :ticket_department
  belongs_to :sub_department

  # Delegations

  delegate :name, :acronym, to: :sub_department, prefix: true, allow_nil: true

  # Validations

  ## Presence

  validates :ticket_department,
    :sub_department,
    presence: true

  validate :sub_department_belongs_to_department?

  validates_uniqueness_of :sub_department_id,
    scope: :ticket_department_id


  private

  def sub_department_belongs_to_department?
    unless sub_department&.department_id == ticket_department&.department_id
      errors.add(:sub_department_id, :belongs)
    end
  end
end
