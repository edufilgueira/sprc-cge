class Topic < ApplicationRecord
  include Topic::Search
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

  belongs_to :organ

  has_many :subtopics, dependent: :destroy, inverse_of: :topic

  # Nested

  accepts_nested_attributes_for :subtopics, allow_destroy: true

  # Delegations

  delegate :acronym, :name, :title, :full_title, to: :organ, prefix: true, allow_nil: true

  #  Validations

  ## Presence

  validates :name,
    presence: true

  validates_uniqueness_of :name,
    scope: :organ_id

  # Callbacks

  before_save :subtopics_set_disabled_at

  # Scopes

  def self.default_sort_column
    'topics.name'
  end

  def self.other_organs
    find_by(other_organs: true)
  end

  def self.not_other_organs
    where.not(other_organs: true)
  end

  def self.only_no_characteristic
    where(name: I18n.t('topic.no_characteristic')).first
  end

  def self.without_no_characteristic
    where.not(name: I18n.t('topic.no_characteristic'))
  end

  # Instace methods

  ## Helpers

  def title
    return name if organ.blank?

    "[#{organ_acronym}] - #{name}"
  end


  private

  def subtopics_set_disabled_at
    subtopics.each(&:set_disabled_at)
  end
end
