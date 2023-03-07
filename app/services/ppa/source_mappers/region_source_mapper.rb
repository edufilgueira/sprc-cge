module PPA::SourceMappers
  class RegionSourceMapper < Base
    maps PPA::Source::Region, to: PPA::Region

    # ignorando regiões sabidas - ex: 15 "ESTADO DO CEARÁ", que não é região!
    default_scope { where.not(codigo_regiao: ['15', '-']) }


    def map
      target = PPA::Region.find_or_initialize_by code: source.codigo_regiao
      target.name = source.descricao_regiao

      target.save! if target.new_record? || target.changed?
      target
    end


    def blacklisted?
      case source.codigo_regiao.to_s.strip
      when '15' # "ESTADO DO CEARÁ"
        logger.warn "Ignorando regiao com código 15"
        true
      when '-' # deveria ser nil, mas serviço volta '-'
        logger.warn "Ignorando regiao sem código (\"-\")"
        true
      else # não está na blacklist
        false
      end
    end
  end
end
