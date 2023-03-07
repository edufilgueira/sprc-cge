#
# Métodos e constantes de busca para Integration::Organ
#

module Integration::Supports::Organ::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = [
  ]

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    LOWER(integration_supports_organs.descricao_orgao) LIKE LOWER(:search) OR
    LOWER(integration_supports_organs.codigo_orgao) LIKE LOWER(:search) OR
    LOWER(integration_supports_organs.sigla) LIKE LOWER(:search)
  }
end
