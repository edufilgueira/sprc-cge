class Api::V1::OrganSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :acronym
end
