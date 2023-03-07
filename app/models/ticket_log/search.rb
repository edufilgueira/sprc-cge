#
# Métodos e constantes de busca para TicketLog
#

module TicketLog::Search
  extend ActiveSupport::Concern
  include Searchable

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = []
end
