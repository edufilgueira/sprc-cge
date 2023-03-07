#
# Métodos e constantes de busca para Integration::Results::StrategicIndicator
#

module Integration::Results::ThematicIndicator::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = [
    :axis,
    :organ,
    :theme
  ]


  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    LOWER(integration_results_thematic_indicators.indicador) LIKE LOWER(:search) OR
    LOWER(integration_results_thematic_indicators.resultado) LIKE LOWER(:search) OR
    LOWER(integration_results_thematic_indicators.orgao) LIKE LOWER(:search) OR
    LOWER(integration_supports_axes.descricao_eixo) LIKE LOWER(:search) OR
    LOWER(integration_supports_themes.descricao_tema) LIKE LOWER(:search) OR
    LOWER(integration_supports_organs.sigla) LIKE LOWER(:search)
  }
end
