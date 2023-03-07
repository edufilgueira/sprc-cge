#
# Classe responsável por imitar um Source, como não temos
# a informação de cidades e suas respectivas regiões essa
# classe toma como base um csv presente em /lib/ppa/city_regions.csv
# e mapeia os valores encontrados para que possa ser utilizada em seu
# respectivo SourceMapper
#
class PPA::Source::CityRegion

  FILE_PATH = "#{Rails.root}/lib/ppa/city_regions.csv"

  class << self
    def all
      @all ||= CSV.read(FILE_PATH).map { |line| new(line) }
    end

    def find_each
      all.each { |record| yield record } if block_given?
    end
  end

  attr_reader :city_code, :city_name, :region_name

  def initialize(line)
    @city_code   = line[0].to_i
    @city_name   = line[1]
    @region_name = line[2]
  end

end
