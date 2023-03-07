#
# Métodos e constantes de busca para Theme
#

module Theme::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_EXPRESSION = %q{
    LOWER(themes.name) LIKE LOWER(:search) OR
    LOWER(themes.code) LIKE LOWER(:search)
  }
end
