module PPA::Calculators
  module Annual
    class RegionalInitiativeBudgetCalculator < Base
      # default scope para cálculo de TODOS os orçamentos anuais!
      # - para os anos 2016..2019
      # - para todas as regiões
      # - para todos os períodos anuais
      default_scope -> do
        scope = []

        years = (2016..2019).to_a
        regions = PPA::Region.pluck :id
        periods = PPA::Annual::Measurement.periods.keys

        years.each do |year|
          regions.each do |region|
            periods.each do |period|
              scope << { year: year, region: region, period: period }
              # attributes - params used in Calculator#initialize
              # as `calculate year: year, region: region, period: period`
            end
          end
        end

        scope
      end

      #
      # atributos do calculador
      #
      # @param [Integer] year: integer
      # @param [PPA::Region,Integer] region: instance or id
      # @param [Integer,String] period: enum as value or string/symbol
      attributes :year, :region, :period


      # transformando e validando atributos
      def after_initialize
        self.region = region.is_a?(Numeric) ? PPA::Region.find(region) : region
        self.period = period.is_a?(Numeric) ? PPA::Annual::Measurement[period] : period.to_s # enum as string!!

        raise ArgumentError, <<~ERR unless valid_period?
          Invalid period #{period.inspect}
        ERR
      end


      #
      #   Calcula, criando ou atualizando registros de PPA::Annual::RegionalInitiativeBudget,
      # que representam os orçamentos de Iniciativas com recortes <ano, regiao>.
      #
      #   Para isso, agrega dados existentes em PPA::Source::Guideline ("Diretrizes"), que fornecem
      # alguns valores relacionados a "Ação" - conceito não formalizado no software, mas que deve
      # ser agrupado por "Iniciativa"
      #
      def calculate
        initiatives.find_each do |initiative|
          expected = expected_budget_for initiative
          actual   = actual_budget_for   initiative

          next if expected.zero? && actual.zero? # XXX ignora orçamentos zerados

          create_or_update_budget_for! initiative, expected: expected, actual: actual
        end
      end


      protected

      def initiatives
        PPA::Initiative.in_year_and_region year, region
      end

      def create_or_update_budget_for!(initiative, **attrs)
        regional_initiative = initiative.annual_regional_initiatives
          .find_or_create_by! year: year, region_id: region

        budget = regional_initiative.budgets.find_or_initialize_by period: period
        budget.attributes = attrs
        budget.save! # if budget.new_record? || budget.changed?
      end

      def expected_budget_for(initiative)
        attr_name = case year
                    when 2016 then :valor_lei_creditos_ano1
                    when 2017 then :valor_lei_creditos_ano2
                    when 2018 then :valor_lei_creditos_ano3
                    when 2019 then :valor_lei_creditos_ano4
                    end

        guidelines_with_budget_for(initiative).sum(attr_name)
      end

      def actual_budget_for(initiative)
        attr_name = case year
                    when 2016 then :valor_empenhado_ano1
                    when 2017 then :valor_empenhado_ano2
                    when 2018 then :valor_empenhado_ano3
                    when 2019 then :valor_empenhado_ano4
                    end

        guidelines_with_budget_for(initiative).sum(attr_name)
      end


      private

      def guidelines_with_budget_for(initiative)
        # XXX usando "ano" como nome do parâmetro para ficar de fato diferente de "year".
        # "ano"  - refere-se ao parâmetro usado na importação do dado - de guideline#ano
        # "year" - refere-se ao ano a que o dado se refere!!!
        ano = case year
              when 2016, 2017 then 2017
              when 2018, 2019 then 2018
              end

        PPA::Source::Guideline
          .with_period
          .where(
            ano: ano,
            codigo_regiao: region.code,
            codigo_ppa_iniciativa: initiative.code,
            descricao_referencia: PPA::Annual::Measurement.descricao_referencia_for_period(period)
          )
      end

      def valid_period?
        PPA::Annual::Measurement.periods.keys.include? period
      end

    end
  end
end
