#
# Métodos e constantes de busca para Integration::Contracts::Contract
#

module Integration::Contracts::Contract::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = [
    :manager, :grantor
  ]

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    (integration_contracts_contracts.isn_sic)::TEXT LIKE LOWER(:search) OR
    LOWER(integration_contracts_contracts.num_contrato) LIKE LOWER(:search) OR
    LOWER(integration_contracts_contracts.plain_num_contrato) LIKE LOWER(:search) OR
    LOWER(integration_contracts_contracts.cpf_cnpj_financiador) LIKE LOWER(:search) OR
    LOWER(integration_contracts_contracts.plain_cpf_cnpj_financiador) LIKE LOWER(:search) OR
    unaccent(LOWER(integration_contracts_contracts.descricao_nome_credor)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(integration_contracts_contracts.descricao_objeto)) LIKE unaccent(LOWER(:search)) OR
    LOWER(integration_supports_organs.sigla) LIKE LOWER(:search) OR
    unaccent(LOWER(integration_supports_organs.descricao_orgao)) LIKE unaccent(LOWER(:search)) OR
    LOWER(integration_supports_management_units.sigla) LIKE LOWER(:search) OR
    unaccent(LOWER(integration_supports_management_units.titulo)) LIKE unaccent(LOWER(:search))
  }
end
