require_dependency 'ppa/biennial/regionalized'
require_dependency 'ppa/biennial/measurable'

module PPA
  module Biennial
    class RegionalInitiative < ApplicationRecord
      include Regionalized
      include Measurable

      regionalizes :initiative
      measurable_from :budgets

      has_many :budgets, dependent: :destroy, class_name: 'PPA::Biennial::RegionalInitiativeBudget'

      has_many :products,
        ->(regional_initiative) do
          in_biennium_and_region(regional_initiative.biennium, regional_initiative.region_id)
            .distinct
        end,
        through: :initiative, source: :biennial_regional_products

      delegate :code, to: :initiative
      delegate :name, to: :initiative, prefix: :original # nome atual da iniciativa
      delegate :name, :code, to: :region, prefix: true

      validates :name, presence: true # nome da iniciativa no biênio - pode ter sofrido revisão e melhorias


      def annual_budgets
        initiative.annual_regional_initiatives.in_year_and_region(biennium.years, region).order(:year)
          .map do |annual_regional_initiative|
            annual_regional_initiative.budgets.latest
          end.compact
      end

    end
  end
end
