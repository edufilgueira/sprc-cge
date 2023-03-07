#
# Métodos e constantes de busca para Integration::Expenses::Ned
#

module Integration::Expenses::Ned::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = [
    :management_unit
    
  ]

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    LOWER(integration_expenses_neds.numero) LIKE LOWER(:search) OR
    LOWER(integration_expenses_neds.cpf_cnpj_credor) LIKE LOWER(:search) OR
    unaccent(LOWER(integration_expenses_neds.razao_social_credor)) LIKE unaccent(LOWER(:search)) OR
    LOWER(integration_expenses_neds.unidade_gestora) LIKE LOWER(:search) OR
    LOWER(integration_supports_management_units.sigla) LIKE LOWER(:search) OR 
    LOWER(integration_expenses_neds.numero_contrato) LIKE LOWER(:search) OR
    LOWER(integration_expenses_neds.especificacao_geral) LIKE LOWER(:search)

  }
end
