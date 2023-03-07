#
# Representa uma subunidade pertencente à uma unidade do órgão
#

class SubDepartment < ApplicationRecord
  include SubDepartment::Search
  include ::Disableable
  include ::Upcaseable

  # Consts

  UPCASE_ATTRIBUTES = [
    :name
  ]

  # Setup

  acts_as_paranoid

  # Associations

  belongs_to :department

  has_many :users
  has_many :ticket_department_sub_departments
  has_many :ticket_departments, through: :ticket_department_sub_departments
  has_many :tickets, through: :ticket_departments

  # Delegation

  delegate :acronym, :organ_acronym, to: :department, prefix: true, allow_nil: true

  # Validations

  ## Presence

  validates :name,
    :acronym,
    :department,
    presence: true


  # Public

  ## Class methods

  ### Scopes

  def self.sorted
    order(:acronym)
  end


  ## Instance methods

  ### Helpers

  def title
    "#{acronym} - #{name}"
  end
end
