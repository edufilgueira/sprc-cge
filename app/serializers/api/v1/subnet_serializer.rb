class Api::V1::SubnetSerializer < ActiveModel::Serializer
  attributes :id,
             :acronym

  attribute :title, key: :name
end
