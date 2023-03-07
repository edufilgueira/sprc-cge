module PPA::SourceMappers
  module Annual
    class RegionalStrategySourceMapper < Base
      maps PPA::Source::Guideline, to: PPA::Annual::RegionalStrategy

      # pre-requisites
      attr_reader :region, :strategy

      def map
        # pre-requisites
        @region   = PPA::Region.find_by! code: source.codigo_regiao
        @strategy = PPA::Strategy.find_by! code: source.codigo_ppa_estrategia

        # target
        biennium.years.each do |year|
          target = strategy.annual_regional_strategies
            .in_year_and_region(year, region)
            .first_or_create!
        end
      end


      def biennium
        @biennium ||= source.biennium
      end

      def blacklisted?
        code = source.codigo_ppa_estrategia

        if ignore? code
          logger.warn "Ignorando Estratégia com código missing (#{code.inspect})"
          true # blacklisted!
        end
      end


      private

      def ignore?(value)
        canonized = value.to_s.strip
        canonized.blank? || canonized == '-'
      end
    end
  end
end
