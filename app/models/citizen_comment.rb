class CitizenComment < ApplicationRecord

  # Callbacks

  # Associations

  belongs_to :ticket
  belongs_to :user

  # Delegations

  delegate :title, to: :user, prefix: true

  # Validations

  ## Presence

  validates :description,
    :user,
    :ticket,
    presence: true


  # Scopes

  def self.sorted
    order(created_at: :desc)
  end

  # Helpers

  def title
    ''
  end

end
