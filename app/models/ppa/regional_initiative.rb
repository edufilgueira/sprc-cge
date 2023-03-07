module PPA
  class RegionalInitiative < ApplicationRecord
    include Regional
    include Measurable

    regionalizes :initiative
    measurable_from :budgets

    has_many :budgets, dependent: :destroy, class_name: 'PPA::RegionalInitiativeBudget'

    delegate :name, :code, to: :product
    delegate :name, :code, to: :region, prefix: true


    def annual_budgets
      initiative.annual_regional_initiatives.in_region(region).order(:year)
        .map do |annual_regional_initiative|
          annual_regional_initiative.budgets.latest
        end.compact
    end

    def biennial_budgets
      initiative.biennial_regional_initiatives.in_region(region).order(:start_year)
        .map do |biennial_regional_initiative|
          biennial_regional_initiative.budgets.latest
        end.compact
    end

  end
end
