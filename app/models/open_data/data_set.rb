#
# Representa um conjunto de Dados Abertos
#

class OpenData::DataSet < ApplicationDataRecord
  include ::Sortable
  include ::OpenData::DataSet::Search

  # Associations

  belongs_to :organ, class_name: 'Integration::Supports::Organ'

  has_many :data_items, foreign_key: :open_data_data_set_id, inverse_of: :data_set, dependent: :destroy
  has_many :data_set_vcge_categories, foreign_key: :open_data_data_set_id, inverse_of: :data_set, dependent: :destroy
  has_many :vcge_categories, through: :data_set_vcge_categories

  #  Nested

  accepts_nested_attributes_for :data_items,
    reject_if: :all_blank,
    allow_destroy: true

  accepts_nested_attributes_for :data_set_vcge_categories,
    reject_if: :all_blank,
    allow_destroy: true

  #  Validations

  ## Presence

  validates :title,
    :organ_id,
    presence: true

  # Public

  ## Class methods

  ### Scopes

  def self.default_sort_column
    'open_data_data_sets.title'
  end

  def self.default_sort_direction
    :asc
  end
end
