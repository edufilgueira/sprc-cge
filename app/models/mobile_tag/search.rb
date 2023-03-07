#
# Métodos e constantes de busca para mobile_tag
#
module MobileTag::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_EXPRESSION = %q{
    LOWER(mobile_tags.name) LIKE LOWER(:search)
  }
end
