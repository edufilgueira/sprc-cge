#
# Métodos e constantes de busca para SearchContent
#

module SearchContent::Search
  extend ActiveSupport::Concern
  include Searchable

  SEARCH_INCLUDES = [ :translations ]

  # Consts

  SEARCH_EXPRESSION = %q{
    unaccent(LOWER(title)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(content)) LIKE unaccent(LOWER(:search))
  }
end
