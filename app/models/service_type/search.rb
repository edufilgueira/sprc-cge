#
# Métodos e constantes de busca para ServiceType
#

module ServiceType::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = [
    :organ
  ]

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    CAST(service_types.code AS TEXT) LIKE :search OR
    LOWER(service_types.name) LIKE LOWER(:search) OR
    LOWER(organs.acronym) LIKE LOWER(:search)
  }
end
