

#
# Métodos e constantes de busca para Integration::Supports::Theme
#

module Integration::Supports::Theme::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = [
  ]

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    LOWER(integration_supports_themes.codigo_tema) LIKE LOWER(:search) OR
    LOWER(integration_supports_themes.descricao_tema) LIKE LOWER(:search)
  }
end
