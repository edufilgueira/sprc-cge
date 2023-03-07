#
# Métodos e constantes de busca para Event
#

module Event::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    LOWER(events.title) LIKE LOWER(:search)
  }
end
