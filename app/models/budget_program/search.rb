#
# Métodos e constantes de busca para BudgetProgram
#

module BudgetProgram::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = [ :theme, :organ, :subnet ]

  SEARCH_EXPRESSION = %q{
    LOWER(budget_programs.name) LIKE LOWER(:search) OR
    LOWER(budget_programs.code) LIKE LOWER(:search) OR
    LOWER(themes.name) LIKE LOWER(:search) OR
    LOWER(organs.acronym) LIKE LOWER(:search) OR
    LOWER(subnets.acronym) LIKE LOWER(:search)
  }
end
