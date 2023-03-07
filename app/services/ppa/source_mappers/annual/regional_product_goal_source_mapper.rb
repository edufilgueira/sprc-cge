module PPA::SourceMappers
  module Annual
    class RegionalProductGoalSourceMapper < Base
      maps PPA::Source::Guideline, to: PPA::Annual::RegionalProductGoal

      # pre-requisites
      attr_reader :region, :product

      def map
        # pre-requisites
        @region  = PPA::Region.find_by!  code: source.codigo_regiao
        @product = PPA::Product.find_by! code: source.codigo_produto

        # target
        biennium.years.each do |year|
          regional_product = product.annual_regional_products
            .by_year_and_region(year, region)
            .first! # já deve existir!

          expected_value = expected_value_for year
          actual_value   = actual_value_for year

          # TODO faz sentido esse recorte? Ignorar orçamentos com valores zerados?
          next if ignore_measurement_value?(expected_value) || ignore_measurement_value?(actual_value)

          target = regional_product.goals
            .find_or_initialize_by(period: period) # TODO ??? como isso funciona?!
          target.attributes = {
            expected: expected_value_for(year),
            actual:   actual_value_for(year)
          }
          target.save! # if target.new_record? || target.changed?
        end
      end


      def biennium
        @biennium ||= source.biennium
      end

      def blacklisted?
        code = source.codigo_produto

        if ignore? code
          logger.warn "Ignorando Produto com código missing (#{code.inspect})"
          true # blacklisted!
        end
      end


      private # helpers de conversão de dado

      def period
        @period ||= PPA::Annual::Measurement.period_for_descricao_referencia(source.descricao_referencia.to_s.strip)
      end

      def expected_value_for(year)
        case year
        when 2016 then source.valor_programado_ano1
        when 2017 then source.valor_programado_ano2
        when 2018 then source.valor_programado_ano3
        when 2019 then source.valor_programado_ano4
        end
      end

      def actual_value_for(year)
        case year
        when 2016 then source.valor_realizado_ano1
        when 2017 then source.valor_realizado_ano2
        when 2018 then source.valor_realizado_ano3
        when 2019 then source.valor_realizado_ano4
        end
      end


      def ignore?(value)
        return true if value.blank?

        value.to_s.strip == '-'
      end

      def ignore_measurement_value?(value)
        return true if value.blank?
        return true if value.respond_to?(:zero?) && value.zero?

        value.to_s.strip == '-'
      end
    end
  end
end
