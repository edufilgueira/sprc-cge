module PPA
  class Axis < ApplicationRecord

  	belongs_to :plan
    has_many :themes, dependent: :destroy

    validates_presence_of :name
    validates_presence_of :code

    validates_uniqueness_of :code, scope: :plan_id
    validates_uniqueness_of :name, scope: :plan_id
  end
end
