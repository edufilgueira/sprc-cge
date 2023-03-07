module PPA::Calculators
  module Biennial
=begin

  Agrega valores de execução física (metas) bienais para Produtos, baseando-se em
dados pré-existentes de execução física anuais (PPA::Annual::RegionalProductGoal)!

=end
    class RegionalProductGoalCalculator < Base
      # default scope para cálculo de TODOS as metas bienais!
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
      #   Calcula, criando ou atualizando registros de PPA::Biennial::RegionalProductGoal,
      # que representam valores de execução física de Produtos com recortes <ano, regiao>.
      #
      #   Para isso, agrega dados existentes em PPA::Annual::RegionalProductGoal, que fornecem
      # valores já consolidados por ano e região.
      #
      def calculate
        products.find_each do |product|
          expected = 0
          actual = 0

          biennium.years.each do |year|
            product_latest_annual_goal = latest_annual_regional_goal_for(product, year)

            expected += product_latest_annual_goal&.expected || 0
            actual   += product_latest_annual_goal&.actual || 0
          end

          next if expected.zero? && actual.zero? # XXX ignora metas zeradas

          create_or_update_goal_for! product, expected: expected, actual: actual
        end
      end


      protected

      def products
        PPA::Product.in_biennium_and_region biennium, region
      end

      def create_or_update_goal_for!(product, **attrs)
        regional_product = product.biennial_regional_products
          .find_or_create_by! start_year: biennium.first, end_year: biennium.last, region_id: region

        goal = regional_product.goals.first_or_initialize
        goal.attributes = attrs
        goal.save! # if goal.new_record? || goal.changed?
      end

      def latest_annual_regional_goal_for(product, year)
        annual_regional_product = product.annual_regional_products
          .in_year_and_region(year, region).first!

        annual_regional_product.goals.latest
      end

    end
  end
end
