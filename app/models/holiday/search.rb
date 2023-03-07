#
# Métodos e constantes de busca para Holiday
#

module Holiday::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_EXPRESSION = %q{
    LOWER(holidays.title) LIKE LOWER(:search) OR
    (holidays.day)::TEXT LIKE LOWER (:search) OR
    (holidays.month)::TEXT LIKE LOWER (:search)
  }
end

