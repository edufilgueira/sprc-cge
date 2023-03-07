#
# Métodos e constantes de busca para Ticket
#

module Mailboxer::Notification::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = [
  ]

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    LOWER(mailboxer_notifications.body) LIKE LOWER(:search) OR
    LOWER(mailboxer_notifications.subject) LIKE LOWER(:search)
  }
  
end
