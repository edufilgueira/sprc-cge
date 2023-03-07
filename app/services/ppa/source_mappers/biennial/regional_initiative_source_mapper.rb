module PPA::SourceMappers
  module Biennial
    class RegionalInitiativeSourceMapper < Base
      maps PPA::Source::Guideline, to: PPA::Biennial::RegionalInitiative

      # pre-requisites
      attr_reader :region, :initiative

      def map
        # pre-requisites
        @region     = PPA::Region.find_by! code: source.codigo_regiao
        @initiative = PPA::Initiative.find_by! code: source.codigo_ppa_iniciativa

        # target
        @target = initiative.biennial_regional_initiatives
          .in_biennium_and_region(biennium, region)
          .first_or_initialize
        @target.name = source.descricao_ppa_iniciativa
        @target.save!
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
