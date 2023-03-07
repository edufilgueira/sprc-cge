module PPA::SourceMappers
  class ObjectiveSourceMapper < Base
    maps PPA::Source::Guideline, to: PPA::Objective

    default_scope -> { where.not codigo_ppa_objetivo_estrategico: '-' }

    #
    # Mapeia uma "Diretriz" em um Objective, e suas associações
    # - Objective (atômico)
    # - Objective has many Themes
    #
    # @return [PPA::RegionalObjective] <description>
    #
    def map
      target = PPA::Objective.find_or_initialize_by code: source.codigo_ppa_objetivo_estrategico
      target.name = source.descricao_objetivo_estrategico

      target.save! if target.new_record? || target.changed?

      # associando tema - é preciso que o regitro esteja persistido!
      theme = PPA::Theme.find_by! code: source.codigo_tema
      target.themes << theme unless target.theme_ids.include? theme.id
      # NOTE a associação acima é "auto-save"

      target
    end


    def blacklisted?
      case source.codigo_ppa_objetivo_estrategico.to_s.strip
      when '-' # missing
        logger.warn "Ignorando Objetivo com código \"-\" (missing)"
        true
      else false
      end
    end
  end
end
