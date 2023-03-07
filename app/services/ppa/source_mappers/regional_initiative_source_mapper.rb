module PPA::SourceMappers
  class RegionalInitiativeSourceMapper < Base
    maps PPA::Source::Guideline, to: PPA::RegionalInitiative

    # pre-requisites
    attr_reader :region, :initiative

    def map
      # pre-requisites
      @region     = PPA::Region.find_by! code: source.codigo_regiao
      @initiative = PPA::Initiative.find_by! code: source.codigo_ppa_iniciativa

      @target = initiative.regional_initiatives.in_region(region).first_or_create!
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
