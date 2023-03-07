require_dependency 'ppa/annual/regionalized'

module PPA
  module Annual
    class RegionalStrategy < ApplicationRecord
      include Regionalized

      regionalizes :strategy

      has_many :initiatives,
               ->(regional_strategy) do
                  in_year_and_region(regional_strategy.year, regional_strategy.region_id).distinct
               end,
               through: :strategy, source: :annual_regional_initiatives

      has_many :products, through: :initiatives, source: :products

    end
  end
end
