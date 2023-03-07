#
# Métodos e constantes de busca para SubDepartment
#

module SubDepartment::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = [
  ]

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    LOWER(sub_departments.name) LIKE LOWER(:search) OR
    LOWER(sub_departments.acronym) LIKE LOWER(:search)
  }
end
