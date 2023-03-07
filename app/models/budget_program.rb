class BudgetProgram < ApplicationRecord
  include ::Sortable
  include ::Disableable
  include ::BudgetProgram::Search

  # Setup

  acts_as_paranoid

  # Associations

  belongs_to :theme
  belongs_to :organ
  belongs_to :subnet

  # Validations

  ## Presence

  validates :name,
    :code,
    presence: true

  # Delegations

  delegate :name, to: :theme, prefix: true, allow_nil: true
  delegate :name, :acronym, :full_acronym, :subnet?, to: :organ, prefix: true, allow_nil: true
  delegate :acronym, :name, to: :subnet, prefix: true, allow_nil: true

  # Scopes

  def self.default_sort_column
    'budget_programs.name'
  end

  def self.other_organs
    find_by(other_organs: true)
  end

  def self.not_other_organs
    where.not(other_organs: true)
  end

  def self.only_no_characteristic
    where(name: I18n.t('budget_program.no_characteristic')).first
  end

  def self.without_no_characteristic
    where.not(name: I18n.t('budget_program.no_characteristic'))
  end

  # Instace methods

  ## Helpers

  def title
    acronym_organ = subnet.present? ? subnet_acronym : organ_acronym

    acronym_organ.blank? ? name : "#{acronym_organ} - #{name}"
  end

end
