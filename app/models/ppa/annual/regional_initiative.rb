require_dependency 'ppa/annual/regionalized'
require_dependency 'ppa/annual/measurable'

module PPA
  module Annual
    class RegionalInitiative < ApplicationRecord
      include Regionalized
      include Measurable

      regionalizes :initiative
      measurable_from :budgets

      has_many :budgets, dependent: :destroy, class_name: 'PPA::Annual::RegionalInitiativeBudget'

      has_many :products,
               ->(regional_initiative) do
                  in_year_and_region(regional_initiative.year, regional_initiative.region_id)
                    .distinct
               end,
               through: :initiative, source: :annual_regional_products

      delegate :name, :code, to: :initiative
      delegate :name, :code, to: :region, prefix: true

    end
  end
end
