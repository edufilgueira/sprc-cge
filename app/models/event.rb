class Event < ApplicationRecord
  include Event::Search
  include ::Sortable

  # Setup

  # Associations

  # Delegation

  # Validations

  validates :title,
    :starts_at,
    :description,
    presence: true

  # Enums

  # Callback

  # Serializers

  # Public

  ## Class methods

  ### Scopes

  def self.default_sort_column
    'events.title'
  end

  def self.upcoming
    where(starts_at: Date.today..Date::Infinity.new).order(:starts_at)
  end

  ## Instance methods

  ### Helpers

end
