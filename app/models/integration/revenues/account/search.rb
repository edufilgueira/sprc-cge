#
# Métodos e constantes de busca para Integration::Revenues::Account
#

module Integration::Revenues::Account::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = [
  ]

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    LOWER(integration_supports_organs.sigla) LIKE LOWER(:search) OR
    LOWER(integration_supports_organs.descricao_entidade) LIKE LOWER(:search) OR
    LOWER(integration_supports_organs.descricao_orgao) LIKE LOWER(:search) OR
    LOWER(integration_supports_revenue_natures.descricao) LIKE LOWER(:search)
  }
end
