class Page::Chart < ApplicationRecord
  include ::Globalizeable

  default_scope -> { order(:id) }

  # Setup

  translates :title, :description, :unit, fallbacks_for_empty_translations: false

  # Associations

  belongs_to :page
  has_many :page_series_data, dependent: :destroy, class_name: 'Page::SeriesDatum',
    foreign_key: :page_chart_id, inverse_of: :page_chart

  # Nested

  accepts_nested_attributes_for :page_series_data, reject_if: :all_blank,
    allow_destroy: true

  # Validations

  ## Presence

  validates :title,
    :page,
    presence: true

end
