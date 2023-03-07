#
# Métodos e constantes de busca para Integration::Creditor
#

module Integration::Supports::Creditor::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = [
  ]

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    LOWER(integration_supports_creditors.codigo) LIKE LOWER(:search) OR
    LOWER(integration_supports_creditors.nome) LIKE LOWER(:search) OR
    (integration_supports_creditors.cpf_cnpj) LIKE (:search) OR
    LOWER(integration_supports_creditors.email) LIKE LOWER(:search) OR
    (integration_supports_creditors.telefone_contato) LIKE (:search)
  }
end
