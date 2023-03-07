class Holiday < ApplicationRecord
  include ::Sortable
  include ::Holiday::Search

  # Setup

  acts_as_paranoid

  # Validations

  validates :day, :month, :title, presence: true

  validates_numericality_of :month, less_than: 13, greater_than: 0
  validates_numericality_of :day, less_than: 32, greater_than: 0

  # Class methods

  ## Scopes

  def self.default_sort_column
    'holidays.month'
  end

  ## Helpers

  def self.next_weekday(days, reference_date = Date.today)
    # garante que seja Date
    reference_date = reference_date.to_date

    date = reference_date + days

    date += 1 until weekday?(date)


    (date - reference_date).to_i
  end

  def self.weekday?(date)
    date.on_weekday? && !Holiday.exists?(day: date.day, month: date.month)
  end

  # Instance methods

  ## Helpers

  def month_str
    I18n.t('date.month_names')[month]
  end

end
