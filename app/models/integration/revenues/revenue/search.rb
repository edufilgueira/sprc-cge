#
# Métodos e constantes de busca para Integration::Revenues::Revenue
#

module Integration::Revenues::Revenue::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = [
  ]

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    LOWER(integration_revenues_revenues.poder) LIKE LOWER(:search) OR
    LOWER(integration_revenues_revenues.titulo) LIKE LOWER(:search) OR
    LOWER(integration_revenues_revenues.administracao) LIKE LOWER(:search)
  }
end
