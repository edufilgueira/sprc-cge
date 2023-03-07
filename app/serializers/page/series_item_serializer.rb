class Page::SeriesItemSerializer < ActiveModel::Serializer
  attribute :title, key: :name
  attribute :value, key: :y
end
