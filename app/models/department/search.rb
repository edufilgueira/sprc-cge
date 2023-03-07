#
# Métodos e constantes de busca para Department
#

module Department::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = [
    :organ,
    :subnet
  ]

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    LOWER(departments.name) LIKE LOWER(:search) OR
    LOWER(departments.acronym) LIKE LOWER(:search) OR
    LOWER(organs.acronym) LIKE LOWER(:search) OR
    LOWER(subnets.acronym) LIKE LOWER(:search)
  }
end
