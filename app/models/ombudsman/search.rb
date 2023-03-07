#
# Métodos e constantes de busca para Ombudsman
#

module Ombudsman::Search
  extend ActiveSupport::Concern
  include Searchable

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    unaccent(LOWER(ombudsmen.title)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(ombudsmen.contact_name)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(ombudsmen.email)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(ombudsmen.phone)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(ombudsmen.address)) LIKE unaccent(LOWER(:search))
  }
end
