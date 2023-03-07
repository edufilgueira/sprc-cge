#
# Métodos e constantes de busca para Integration::CityUndertakings::CityUndertaking
#

module Integration::CityUndertakings::CityUndertaking::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = [
    :creditor
  ]
  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    LOWER(integration_city_undertakings_city_undertakings.sic::VARCHAR) LIKE LOWER(:search) OR
    unaccent(LOWER(integration_city_undertakings_city_undertakings.municipio)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(integration_city_undertakings_city_undertakings.mapp)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(integration_supports_creditors.nome)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(integration_city_undertakings_city_undertakings.tipo_despesa)) LIKE unaccent(LOWER(:search))
  }

end
