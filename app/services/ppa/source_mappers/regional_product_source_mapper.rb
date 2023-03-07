module PPA::SourceMappers
  class RegionalProductSourceMapper < Base
    maps PPA::Source::Guideline, to: PPA::RegionalProduct

    # pre-requisites
    attr_reader :region, :product

    def map
      # pre-requisites
      @region  = PPA::Region.find_by! code: source.codigo_regiao
      @product = PPA::Product.find_by! code: source.codigo_produto

      @target = product.regional_products.in_region(region).first_or_create!
    end


    def blacklisted?
      code = source.codigo_produto

      if ignore? code
        logger.warn "Ignorando Produto com código missing (#{code.inspect})"
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
