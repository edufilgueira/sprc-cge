#
# Métodos e constantes de busca para Subnet
#

module Subnet::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = [
    :organ
  ]

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    LOWER(subnets.name) LIKE LOWER(:search) OR
    LOWER(subnets.acronym) LIKE LOWER(:search) OR
    LOWER(organs.acronym) LIKE LOWER(:search)
  }
end
