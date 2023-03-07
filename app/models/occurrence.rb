class Occurrence < ApplicationRecord
  # Setup

  acts_as_paranoid

  # Associations

  belongs_to :attendance
  belongs_to :created_by, class_name: 'User'

  # Delegations

  delegate :title, to: :created_by, prefix: true, allow_nil: true

  # Validations

  ## Presence

  validates :description,
    presence: true

end
