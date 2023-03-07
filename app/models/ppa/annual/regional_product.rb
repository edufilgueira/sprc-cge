require_dependency 'ppa/annual/regionalized'
require_dependency 'ppa/annual/measurable'

module PPA
  module Annual
    class RegionalProduct < ApplicationRecord
      include Regionalized
      include Measurable

      regionalizes :product
      measurable_from :goals

      has_many :goals, dependent: :destroy, class_name: 'PPA::Annual::RegionalProductGoal'

      delegate :name, :code, to: :product
      delegate :name, :code, to: :region, prefix: true

    end
  end
end
