require_dependency 'ppa/biennial/regionalized'
require_dependency 'ppa/biennial/measurable'

module PPA
  module Biennial
    class RegionalProduct < ApplicationRecord
      include Regionalized
      include Measurable

      regionalizes :product
      measurable_from :goals

      has_many :goals, dependent: :destroy, class_name: 'PPA::Biennial::RegionalProductGoal'

      delegate :name, to: :product

      delegate :name, :code, to: :product
      delegate :name, :code, to: :region, prefix: true

    end
  end
end
