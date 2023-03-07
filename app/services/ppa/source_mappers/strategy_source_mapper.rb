module PPA::SourceMappers
  class StrategySourceMapper < Base
    maps PPA::Source::Guideline, to: PPA::Strategy

    default_scope { where.not codigo_ppa_estrategia: '-' }

    # pre-requisites
    attr_reader :region

    #
    # Mapeia uma "Diretriz" em uma Strategy, e suas associações
    # - Strategy (atômico)
    # - Strategy belongs to Objective
    # - Strategy has many Annual::RegionalStrategies
    # - Strategy has many Biennial::RegionalStrategies
    #
    # @return [PPA::Strategy] <description>
    #
    def map
      # pre-requisites
      @region = PPA::Region.find_by! code: source.codigo_regiao
      objective = PPA::Objective.find_by! code: source.codigo_ppa_objetivo_estrategico

      # target
      @target = PPA::Strategy.find_or_initialize_by code: source.codigo_ppa_estrategia
      @target.objective = objective
      @target.name = source.descricao_estrategia

      @target.save! # if target.new_record? || target.changed?

      # has many annual regional strategies
      PPA::SourceMappers::Annual::RegionalStrategySourceMapper.map source

      # has many biennial regional strategies
      # mas no contexto da importação, só haverá um biennial relacionado
      PPA::SourceMappers::Biennial::RegionalStrategySourceMapper.map source
    end


    def blacklisted?
      case source.codigo_ppa_estrategia.to_s.strip
      when '-' # missing
        logger.warn "Ignorando Estratégia com código \"-\" (missing)"
        true
      else false
      end
    end


    private

    def ignore?(value)
      canonized = value.to_s.strip
      canonized.blank? || canonized == '-'
    end
  end
end
