#
# Métodos e constantes de busca para ServicesRatingExport
#

module ServicesRatingExport::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    LOWER(services_rating_exports.name) LIKE LOWER(:search)
  }
end
