#
# Métodos e constantes de busca para Ticket
#

module Ticket::Search
  extend ActiveSupport::Concern
  include Searchable

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    tickets.parent_protocol LIKE :search OR
    LOWER(tickets.name) LIKE LOWER(:search) OR
    LOWER(tickets.social_name) LIKE LOWER(:search) OR
    LOWER(tickets.email) LIKE LOWER(:search) OR
    LOWER(tickets.description) LIKE LOWER(:search) OR
    LOWER(tickets.denunciation_description) LIKE LOWER(:search) OR
    LOWER(tickets.document) LIKE LOWER(:search)
  }
end
