#
# Representa uma unidade pertencente à um órgão da administração (CAGECE, ...)
#

class Department < ApplicationRecord
  include ::Sortable
  include ::Disableable
  include ::Upcaseable
  include ::Department::Search

  # Consts

  UPCASE_ATTRIBUTES = [
    :name
  ]

  # Setup

  acts_as_paranoid

  # Associations

  belongs_to :organ
  belongs_to :subnet

  has_many :sub_departments, dependent: :destroy, inverse_of: :department

  has_many :users
  has_many :ticket_departments
  has_many :tickets, through: :ticket_departments

  #  Delegations

  delegate :name, :acronym, :full_acronym, to: :organ, prefix: true, allow_nil: true
  delegate :name, :acronym, :full_acronym, to: :subnet, prefix: true, allow_nil: true

  #  Nesteds

  accepts_nested_attributes_for :sub_departments,
    reject_if: :all_blank,
    allow_destroy: true

  # Validations

  ## Presence

  validates :name,
    presence: true

  validates :organ,
    presence: true,
    unless: -> { subnet.present? }

  validates :subnet,
    presence: true,
    unless: -> { organ.present? }

  validates_uniqueness_of :acronym,
    scope: [ :organ_id,  :subnet_id ],
    if: :acronym? # acronym é opcional!

  validates_uniqueness_of :name,
    scope: [ :organ_id, :subnet_id ]

  # Callbacks

  before_save :sub_departments_set_disabled_at

  # Public

  ## Class methods

  ### Scopes

  def self.default_sort_column
    'departments.acronym'
  end

  def self.sorted_by_organ
    joins(:organ).order('organs.acronym, name')
  end

  def self.from_organ(organ)
    where(organ: organ)
  end

  def self.only_no_characteristic
    where(name: I18n.t('department.no_characteristic')).first
  end

  def self.without_no_characteristic
    where.not(name: I18n.t('department.no_characteristic'))
  end

  ## Instance methods

  ### Helpers

  def title
    acronym_organ = subnet.present? ? subnet_acronym : organ_acronym

    "[#{acronym_organ}] #{acronym} - #{name}"
  end

  def short_title
    "#{acronym} - #{name}"
  end

  def full_acronym
    acronym_organ = subnet.present? ? subnet_acronym : organ_acronym

    "#{acronym_organ} - #{acronym}"
  end

  private

  def sub_departments_set_disabled_at
    sub_departments.each(&:set_disabled_at)
  end
end
