module PPA::SourceMappers
  class InitiativeSourceMapper < Base
    maps PPA::Source::Guideline, to: PPA::Initiative

    default_scope { where.not codigo_ppa_iniciativa: '-' }

    # pre-requisites
    attr_reader :region, :strategy

    #
    # Mapeia uma "Diretriz" em uma Initiative, e suas associações
    # - Initiative (atômico)
    # - Initiative has many Strategies
    # - Initiative has many Annual:RegionalInitiatives
    #
    # @return [PPA::Initiative] <description>
    #
    def map
      # pre-requisites
      @region   = PPA::Region.find_by!   code: source.codigo_regiao
      @strategy = PPA::Strategy.find_by! code: source.codigo_ppa_estrategia

      # target
      @target = PPA::Initiative.find_or_initialize_by code: source.codigo_ppa_iniciativa
      @target.name = source.descricao_ppa_iniciativa

      @target.save! if target.new_record? || target.changed?

      # has many Strategies
      # auto saves!
      @target.strategies << strategy unless target.strategy_ids.include? strategy.id

      # annual associations
      # --
      # has many annual regional initiatives
      PPA::SourceMappers::Annual::RegionalInitiativeSourceMapper.map source

      # biennial associations
      # --
      # has many biennial regional initiatives
      PPA::SourceMappers::Biennial::RegionalInitiativeSourceMapper.map source

      # quadrennial associations
      # --
      # has many (quadrennial) regional initiatives
      PPA::SourceMappers::RegionalInitiativeSourceMapper.map source
    end


    def blacklisted?
      # FIXME os dados ainda estão retornando estratégias com código '-'!
      # Precisamos remover essa verificação de código de estratégia daqui!
      codes = [
        source.codigo_ppa_estrategia.to_s.strip,
        source.codigo_ppa_iniciativa.to_s.strip
      ]

      # case code
      # when nil, '', '-' # missing
        # logger.warn "Ignorando Iniciativa com código #{code.inspect} (missing)"
      if codes.any? { |code| [nil, '', '-'].include?(code) }
        logger.warn "Ignorando Iniciativa com código #{codes.inspect} (missing)"
        true # blaklist!
      end
    end


    private

    def ignore?(value)
      canonized = value.to_s.strip
      canonized.blank? || canonized == '-'
    end
  end
end
