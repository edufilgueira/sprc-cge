class Page::SeriesItem < ApplicationRecord
  include ::Globalizeable

  default_scope -> { order(:id) }

  # Setup

  translates :title, fallbacks_for_empty_translations: false

  # Associations

  belongs_to :page_series_datum, class_name: 'Page::SeriesDatum'

  # Validations

  ## Presence

  validates :title,
    :value,
    :page_series_datum,
    presence: true
end
