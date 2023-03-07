class AttendanceResponse < ApplicationRecord

  # Constants

  # Callbacks

  # Associations

  belongs_to :ticket

  # Enums

  enum response_type: [:failure, :success]

  # Delegations

  delegate :title, to: :ticket, prefix: true, allow_nil: true

  # Validations

  ## Presence

  validates :description,
    :response_type,
    :ticket,
    presence: true

  # Scopes

  def self.sorted
    order(:created_at)
  end
end
