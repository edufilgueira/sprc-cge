class City < ApplicationRecord

  # Setup

  # Associations

  belongs_to :state
  belongs_to :region, class_name: 'PPA::Region'


  # Delegations

  delegate :acronym, to: :state, prefix: true
  delegate :name, to: :region, prefix: true, allow_nil: true


  #  Validations

  ## Presence

  validates :code,
    :name,
    :state,
    presence: true

  ## Uniqueness

  validates :code,
    uniqueness: true

  # Scopes

  def self.sorted
    order(:name)
  end

  # Instace methods

  ## Helpers

  def title
    "#{name}/#{state_acronym}"
  end
end
