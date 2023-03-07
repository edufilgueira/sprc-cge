class Page::SeriesDatumSerializer < ActiveModel::Serializer
  attribute :title, key: :name
  attribute :series_type, key: :type

  has_many :page_series_items, key: :data
end
