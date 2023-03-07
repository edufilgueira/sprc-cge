class Subtopic < ApplicationRecord
  include ::Sortable
  include ::Disableable
  include ::Upcaseable

  # Consts

  UPCASE_ATTRIBUTES = [
    :name
  ]

  # Setup

  acts_as_paranoid

  # Associations

  belongs_to :topic

  #  Validations

  ## Presence

  validates :name,
    :topic,
    presence: true

  validates :name,
    uniqueness: { scope: :topic_id }

  # Scopes

  def self.sorted
    order(:name)
  end

  def self.other_organs
    find_by(other_organs: true)
  end

  def self.not_other_organs
    where.not(other_organs: true)
  end

  # Instace methods

  ## Helpers

  def title
    name
  end
end
