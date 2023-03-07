class AttendanceOrganSubnet < ApplicationRecord

  # Setup

  # Associations

  belongs_to :attendance
  belongs_to :organ
  belongs_to :subnet

  # Enums

  # Delegations

  delegate :full_title, :subnet?, to: :organ, prefix: true, allow_nil: true
  delegate :full_acronym, to: :subnet, prefix: true, allow_nil: true

  # Validations

  ## Presence

  validates :attendance,
    :organ,
    presence: true

  validates :subnet,
    presence: true,
    if: -> { organ_subnet? && !unknown_subnet? }
  
  validates_uniqueness_of :attendance_id, scope: [:organ_id, :subnet_id]

  # Callbacks

  # Instance methods

  ## Helpers

  # Privates
end
