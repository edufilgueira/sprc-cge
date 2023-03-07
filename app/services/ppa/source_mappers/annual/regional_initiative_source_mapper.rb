module PPA::SourceMappers
  module Annual
    class RegionalInitiativeSourceMapper < Base
      maps PPA::Source::Guideline, to: PPA::Annual::RegionalInitiative

      # pre-requisites
      attr_reader :region, :initiative

      def map
        # pre-requisites
        @region     = PPA::Region.find_by! code: source.codigo_regiao
        @initiative = PPA::Initiative.find_by! code: source.codigo_ppa_iniciativa

        # target
        biennium.years.each do |year|
          target = initiative.annual_regional_initiatives
            .in_year_and_region(year, region)
            .first_or_create!
        end
      end


      def biennium
        @biennium ||= source.biennium
      end

      def blacklisted?
        code = source.codigo_ppa_iniciativa

        if ignore? code
          logger.warn "Ignorando Iniciativa com código missing (#{code.inspect})"
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
