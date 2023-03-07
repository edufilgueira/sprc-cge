#
# Métodos e constantes de busca para Page
#

module Page::Search
  extend ActiveSupport::Concern
  include Searchable

  SEARCH_INCLUDES = [ :translations ]

  # Consts

  SEARCH_EXPRESSION = %q{
    unaccent(LOWER(page_translations.title)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(page_translations.menu_title)) LIKE unaccent(LOWER(:search))
  }
end
