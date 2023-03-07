class Page::SeriesDatum < ApplicationRecord
  include ::Globalizeable

  default_scope -> { order(:id) }

  # Setup

  translates :title, fallbacks_for_empty_translations: false

  enum series_type: [:column, :line, :area]

  # Associations

  belongs_to :page_chart, class_name: 'Page::Chart'

  has_many :page_series_items, dependent: :destroy, class_name: 'Page::SeriesItem',
    foreign_key: :page_series_datum_id, inverse_of: :page_series_datum

  # Nested

  accepts_nested_attributes_for :page_series_items, reject_if: :all_blank,
    allow_destroy: true

  # Validations

  ## Presence

  validates :title,
    :series_type,
    :page_chart,
    presence: true
end
