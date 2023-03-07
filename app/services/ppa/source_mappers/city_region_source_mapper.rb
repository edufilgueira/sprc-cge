#
# Mapper responsável por associar as cidades dos Ceará em
# suas respectivas regiões admistrativas
#
module PPA::SourceMappers
  class CityRegionSourceMapper < Base
    maps PPA::Source::CityRegion, to: PPA::City

    # Como é uma classe adaptada, precisamos aplicar #each no ::all, que é um Array e não responde
    # a #find_each - iterator padrão do SourceMappers::Base.
    default_scope with: :each

    def map
      target = PPA::City.find_by code: source.city_code
      region = PPA::Region.where('LOWER(name) = ?', source.region_name.downcase).first

      if target && region
        target.ppa_region_id = region.id
        target.save! if target.changed?
      end

      target
    end

  end
end
