class Page::ChartSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :unit

  has_many :page_series_data, key: :series
end
