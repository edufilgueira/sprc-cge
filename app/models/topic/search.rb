#
# Métodos e constantes de busca para tópicos
#

module Topic::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = [
    :organ,
    :subtopics
  ]

  SEARCH_EXPRESSION = %q{
    LOWER(topics.name) LIKE LOWER(:search) OR
    LOWER(organs.acronym) LIKE LOWER(:search) OR
    LOWER(organs.name) LIKE LOWER(:search) OR
    LOWER(subtopics.name) LIKE LOWER(:search)
  }
end
