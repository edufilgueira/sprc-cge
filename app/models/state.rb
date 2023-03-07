class State < ApplicationRecord

  # Setup

  # Associations

  has_many :cities, dependent: :destroy


  #  Validations

  ## Presence

  validates :name,
    :code,
    :acronym,
    presence: true

  ## Uniqueness

  validates :code,
    :acronym,
    uniqueness: true

  # Scopes

  def self.sorted
    order(:name)
  end

  def self.default
    find_by(acronym: 'CE')
  end

  # Instace methods

  ## Helpers

  def title
    name
  end
end
