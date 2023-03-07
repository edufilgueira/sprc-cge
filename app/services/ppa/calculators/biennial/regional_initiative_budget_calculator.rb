module PPA::Calculators
  module Biennial
=begin

  Agrega valores de orçamento bienais para Iniciativas, baseando-se em dados pré-existentes de
Orçamentos anuais! (@see PPA::Calculators::Annual::RegionalInitiativeBudgetCalculator)

=end
    class RegionalInitiativeBudgetCalculator < Base
      # default scope para cálculo de TODOS os orçamentos bienais!
      # - para os biênios 2016-2017 e 2018-2019
      # - para todas as regiões
      default_scope -> do
        scope = []

        bienniums = [[2016, 2017], [2018, 2019]].map { |years| PPA::Biennium.new years }
        regions = PPA::Region.pluck :id

        bienniums.each do |biennium|
          regions.each do |region|
            scope << { biennium: biennium, region: region }
            # attributes - params used in Calculator#initialize
            # as `calculate biennium: biennium, region: region`
          end
        end

        scope
      end

      #
      # atributos do calculador
      #
      # @param [PPA::Biennium] biennium: biennium
      # @param [PPA::Region,Integer] region: instance or id
      attributes :biennium, :region


      # transformando e validando atributos
      def after_initialize
        self.biennium = PPA::Biennium.new biennium # permitindo parse de dados básicos (Array, String)
        self.region   = region.is_a?(Numeric) ? PPA::Region.find(region) : region
      end


      #
      #   Calcula, criando ou atualizando registros de PPA::Biennial::RegionalInitiativeBudget,
      # que representam os orçamentos de Iniciativas com recortes <ano, regiao>.
      #
      #   Para isso, agrega dados existentes em PPA::Annual::RegionalInitiativeBudget, que fornecem
      # valores já consolidados por ano e região.
      #
      def calculate
        initiatives.find_each do |initiative|
          expected = 0
          actual = 0

          biennium.years.each do |year|
            initiative_latest_annual_budget = latest_annual_regional_budget_for(initiative, year)

            expected += initiative_latest_annual_budget&.expected || 0
            actual   += initiative_latest_annual_budget&.actual || 0
          end

          next if expected.zero? && actual.zero? # XXX ignora orçamentos zerados

          create_or_update_budget_for! initiative, expected: expected, actual: actual
        end
      end


      protected

      def initiatives
        PPA::Initiative.in_biennium_and_region biennium, region
      end

      def create_or_update_budget_for!(initiative, **attrs)
        regional_initiative = initiative.biennial_regional_initiatives
          .find_or_create_by! start_year: biennium.first, end_year: biennium.last, region_id: region

        budget = regional_initiative.budgets.first_or_initialize
        budget.attributes = attrs
        budget.save! # if budget.new_record? || budget.changed?
      end

      def latest_annual_regional_budget_for(initiative, year)
        annual_regional_initiative = initiative.annual_regional_initiatives
          .in_year_and_region(year, region).first!

        annual_regional_initiative.budgets.latest
      end

    end
  end
end
