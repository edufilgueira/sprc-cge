module PPA::SourceMappers
  class AxisSourceMapper < Base
    maps PPA::Source::AxisTheme, to: PPA::Axis

    default_scope { where.not(codigo_eixo: '-') }

    def map
      target = PPA::Axis.find_or_initialize_by code: source.codigo_eixo
      target.name = source.descricao_eixo

      target.save! if target.new_record? || target.changed?
      target
    end


    def blacklisted?
      case source.codigo_eixo.to_s.strip
      when '-'
        logger.warn "Ignorando Eixo sem código (\"-\")"
        true
      else false
      end
    end
  end
end
