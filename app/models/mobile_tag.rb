class MobileTag < ApplicationRecord
  include MobileTag::Search

  # Setup

  # Associations

  # Delegations


  #  Validations

  ## Presence

  validates :name,
    presence: true

  ## Uniqueness

  validates :name,
    uniqueness: true

  # Scopes

  def self.sorted
    order(:name)
  end

  # Instace methods

  ## Helpers

  def title
    name
  end
end
