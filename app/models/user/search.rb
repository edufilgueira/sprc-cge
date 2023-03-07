#
# Métodos e constantes de busca para user
#

module User::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_EXPRESSION = %q{
    LOWER(users.name) LIKE LOWER(:search) OR
    LOWER(users.social_name) LIKE LOWER(:search) OR
    LOWER(users.email) LIKE LOWER(:search)
  }
end
