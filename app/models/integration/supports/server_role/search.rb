#
# Métodos e constantes de busca para Integration::Supports::ServerRole
# É usado apenas pelo FILTERED_CONTROLLER com organ
#

module Integration::Supports::ServerRole::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = {

  }

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{}
end
