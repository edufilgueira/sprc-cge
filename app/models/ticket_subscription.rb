class TicketSubscription < ApplicationRecord

  # Setup

  # Associations

  belongs_to :ticket
  belongs_to :user

  # Enums

  # Delegations

  # Validations

  ## Presence

  validates :ticket,
    :email,
    presence: true

  validates_uniqueness_of :email,
    scope: :ticket_id

  ## Uniqueness

  # Callbacks

  # Instance methods
  def confirm!
    self.confirmed_email = true
    self.save
  end

  ## Helpers

  # Private

end
