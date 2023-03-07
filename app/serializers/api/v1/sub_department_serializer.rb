class Api::V1::SubDepartmentSerializer < ActiveModel::Serializer
  attributes :id

  attribute :title, key: :name
end
