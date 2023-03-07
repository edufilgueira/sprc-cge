#
# Métodos e constantes de busca para Integration::Expenses::Npf
#

module Integration::Expenses::Npf::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = [
    :creditor,
    :management_unit
  ]

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    LOWER(integration_expenses_npfs.numero) LIKE LOWER(:search) OR
    LOWER(integration_expenses_npfs.credor) LIKE LOWER(:search) OR
    LOWER(integration_expenses_npfs.unidade_gestora) LIKE LOWER(:search) OR
    LOWER(integration_supports_creditors.nome) LIKE LOWER(:search)
  }
end
