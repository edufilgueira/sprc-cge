#
# Métodos e constantes de busca para Integration::Servers::ServerSalary
#

module Integration::Servers::Server::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = [
  	
  ]

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    unaccent(LOWER(integration_servers_servers.dsc_funcionario)) LIKE unaccent(LOWER(:search)) 
  }

 
end
