module PPA
  class RegionalProduct < ApplicationRecord
    include Regional
    include Measurable

    regionalizes :product
    measurable_from :goals

    has_many :goals, dependent: :destroy, class_name: 'PPA::RegionalProductGoal'

    delegate :name, :code, to: :product
    delegate :name, :code, to: :region, prefix: true


    def annual_goals
      product.annual_regional_productss.in_region(region).order(:year)
        .map do |annual_regional_products|
          annual_regional_products.goals.latest
        end.compact
    end

    def biennial_goals
      product.biennial_regional_products.in_region(region).order(:start_year)
        .map do |biennial_regional_product|
          biennial_regional_product.goals.latest
        end.compact
    end
  end
end
