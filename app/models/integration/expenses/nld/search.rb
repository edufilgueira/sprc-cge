#
# Métodos e constantes de busca para Integration::Expenses::Nld
#

module Integration::Expenses::Nld::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = [
    :creditor,
    :management_unit
  ]

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    LOWER(integration_expenses_nlds.numero) LIKE LOWER(:search) OR
    LOWER(integration_expenses_nlds.credor) LIKE LOWER(:search) OR
    LOWER(integration_expenses_nlds.unidade_gestora) LIKE LOWER(:search) OR
    LOWER(integration_supports_creditors.nome) LIKE LOWER(:search)
  }
end
