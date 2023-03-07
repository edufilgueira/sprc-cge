class TicketLike < ApplicationRecord

  # Setup

  # Associations

  belongs_to :ticket
  belongs_to :user

  # Enums

  # Delegations

  # Validations

  ## Presence

  validates :ticket,
    :user,
    presence: true

  ## Uniqueness

  # Callbacks

  # Instance methods

  ## Helpers

  # Private

end
