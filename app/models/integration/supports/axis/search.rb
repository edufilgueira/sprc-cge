

#
# Métodos e constantes de busca para Integration::Supports::Axis
#

module Integration::Supports::Axis::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = [
  ]

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    LOWER(integration_supports_axes.codigo_eixo) LIKE LOWER(:search) OR
    LOWER(integration_supports_axes.descricao_eixo) LIKE LOWER(:search)
  }
end
