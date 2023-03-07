#
# Métodos e constantes de busca para Integration::Expenses::Npd
#

module Integration::Expenses::Npd::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = [
    :creditor,
    :management_unit
  ]

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    LOWER(integration_expenses_npds.numero) LIKE LOWER(:search) OR
    LOWER(integration_expenses_npds.credor) LIKE LOWER(:search) OR
    LOWER(integration_expenses_npds.unidade_gestora) LIKE LOWER(:search) OR
    LOWER(integration_supports_creditors.nome) LIKE LOWER(:search) OR
    LOWER(integration_supports_management_units.sigla) LIKE LOWER(:search) OR
    LOWER(integration_supports_management_units.titulo) LIKE LOWER(:search)
  }
end
