class Api::V1::DepartmentSerializer < ActiveModel::Serializer
  attributes :id

  attribute :short_title, key: :name
end
