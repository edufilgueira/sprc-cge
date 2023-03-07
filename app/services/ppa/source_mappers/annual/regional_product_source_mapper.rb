module PPA::SourceMappers
  module Annual
    class RegionalProductSourceMapper < Base
      maps PPA::Source::Guideline, to: PPA::Annual::RegionalProduct

      # pre-requisites
      attr_reader :region, :product

      def map
        # pre-requisites
        @region  = PPA::Region.find_by!  code: source.codigo_regiao
        @product = PPA::Product.find_by! code: source.codigo_produto

        # target
        biennium.years.each do |year|
          target = product.annual_regional_products
            .by_year_and_region(year, region)
            .first_or_create!
        end
      end


      def biennium
        @biennium ||= source.biennium
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
end
