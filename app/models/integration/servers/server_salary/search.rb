#
# Métodos e constantes de busca para Integration::Servers::ServerSalary
#

module Integration::Servers::ServerSalary::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = [
    :registration,
    [registration: :organ],
    :role
  ]

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    unaccent(LOWER(integration_servers_server_salaries.server_name)) LIKE unaccent(LOWER(:search))
  }


end
