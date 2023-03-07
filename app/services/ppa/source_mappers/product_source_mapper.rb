module PPA::SourceMappers
  class ProductSourceMapper < Base
    maps PPA::Source::Guideline, to: PPA::Product

    default_scope { where.not codigo_produto: '-' }

    # pre-requisites
    attr_reader :region, :initiative

    #
    # Mapeia uma "Diretriz" em uma Product, e suas associações
    # - Product (atômico)
    #   - belongs to Initiative
    #   - has many Annual::RegionalProducts
    #   - has many Annual::RegionalProductGoals (through RegionalProducts)
    #
    # @return [PPA::Product] o produto (re)importado
    #
    def map
      # pre-requisites
      @region     = PPA::Region.find_by!     code: source.codigo_regiao
      @initiative = PPA::Initiative.find_by! code: source.codigo_ppa_iniciativa

      # target
      @target = PPA::Product.find_or_initialize_by code: source.codigo_produto
      @target.initiative = initiative # belongs to Initiative
      @target.name = source.descricao_produto

      @target.save! # if target.new_record? || target.changed?

      # annual associations
      # --
      # has many annual regional products
      ::PPA::SourceMappers::Annual::RegionalProductSourceMapper.map source
      # has many regional product goals (through)
      ::PPA::SourceMappers::Annual::RegionalProductGoalSourceMapper.map source


      # biennial associations
      # --
      ::PPA::SourceMappers::Biennial::RegionalProductSourceMapper.map source

      # quadrennial associations
      # --
      ::PPA::SourceMappers::RegionalProductSourceMapper.map source
    end


    def blacklisted?
      code = source.codigo_produto

      if ignore? code
        logger.warn "Ignorando Produto com código missing (#{code.inspect})"
        true # blacklisted!
      end
    end


    private # helpers de conversão de dado

    def ignore?(value)
      canonized = value.to_s.strip
      canonized.blank? || canonized == '-'
    end
  end
end
