class Subnet < ApplicationRecord
  include ::Sortable
  include ::Disableable
  include ::Subnet::Search

  # Setup

  acts_as_paranoid

  # Associations

  belongs_to :organ

  has_many :departments
  has_many :sub_departments, through: :departments
  has_many :users
  has_many :tickets

  #  Delegations

  delegate :name, :acronym, :full_acronym, to: :organ, prefix: true, allow_nil: true

  # Validations

  ## Presence

  validates :name,
    :organ,
    presence: true

  # Public

  ## Class methods

  ### Scopes

  def self.default_sort_column
    'subnets.acronym'
  end

  def self.sorted_by_organ
    joins(:organ).order('organs.acronym, name')
  end

  def self.from_organ(organ)
    where(organ: organ)
  end

  ## Instance methods

  ### Helpers

  def title
    "[#{acronym}] #{name}"
  end

  def full_acronym
    "[#{organ_acronym}] #{acronym}"
  end
end
