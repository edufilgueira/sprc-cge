module PPA::SourceMappers
  class ThemeSourceMapper < Base
    maps PPA::Source::AxisTheme, to: PPA::Theme

    default_scope { where.not codigo_tema: '-' }

    def map
      axis = PPA::Axis.find_by! code: source.codigo_eixo

      target = PPA::Theme.find_or_initialize_by code: source.codigo_tema, axis_id: axis.id
      target.name = theme_name_with_fallback

      target.save! if target.new_record? || target.changed?
      target
    end


    def blacklisted?
      case source.codigo_tema.to_s.strip
      when '-'
        logger.warn "Ignorando Tema sem código (\"-\")"
        true
      else false
      end
    end


    private

    def ignore?(value)
      canonized = value.to_s.strip
      canonized.blank? || canonized == '-'
    end

    # XXX patch fallback para nome do Tema, dado que o webservice EixoTema (AxisTheme::Importer)
    # não está retornando o dado em `#descricao_tema` enquanto o ListagemDiretrizes (Guideline::Importer)
    # está
    def theme_name_with_fallback
      name = source.descricao_tema
      return name unless ignore? name

      # fallback
      guideline = PPA::Source::Guideline.where.not(descricao_tema: ['', nil, '-'])
        .find_by codigo_eixo: source.codigo_eixo, codigo_tema: source.codigo_tema

      guideline&.descricao_tema || name
    end
  end
end
