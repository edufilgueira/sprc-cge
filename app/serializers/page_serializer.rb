class PageSerializer < ActiveModel::Serializer
  attributes :id

  has_many :page_charts
end
