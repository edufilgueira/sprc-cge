#
# Métodos e constantes de busca para Attendance
#

module Attendance::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = [
    :ticket
  ]

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    CAST(attendances.protocol AS TEXT) LIKE :search OR
    LOWER(attendances.description) LIKE LOWER(:search) OR
    LOWER(tickets.name) LIKE LOWER(:search) OR
    LOWER(tickets.document) LIKE LOWER(:search) OR
    LOWER(tickets.email) LIKE LOWER(:search)
  }
end
