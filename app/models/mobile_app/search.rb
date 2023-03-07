#
# Métodos e constantes de busca para mobile_tag
#
module MobileApp::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_EXPRESSION = %q{
    LOWER(mobile_apps.name) LIKE LOWER(:search) OR
    LOWER(mobile_apps.description) LIKE LOWER(:search)
  }
end
