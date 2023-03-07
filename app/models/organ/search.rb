#
# Métodos e constantes de busca para Organ
#

module Organ::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_EXPRESSION = %q{
    LOWER(name) LIKE LOWER(:search) OR
    LOWER(acronym) LIKE LOWER(:search)
  }
end
