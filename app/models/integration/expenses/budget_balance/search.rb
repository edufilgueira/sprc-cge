#
# Métodos e constantes de busca para Integration::Expenses::BudgetBalance
#

module Integration::Expenses::BudgetBalance::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = [
  ]

  # unaccent(LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    unaccent(LOWER(integration_supports_organs.descricao_entidade)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(integration_supports_organs.descricao_orgao)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(integration_supports_functions.titulo)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(integration_supports_sub_functions.titulo)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(integration_supports_government_programs.titulo)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(integration_supports_government_actions.titulo)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(integration_supports_administrative_regions.titulo)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(integration_supports_expense_natures.titulo)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(integration_supports_qualified_resource_sources.titulo)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(integration_supports_finance_groups.titulo)) LIKE unaccent(LOWER(:search))
  }
end
