#
# Métodos e constantes de busca para Integration::RealStates::RealState
#

module Integration::RealStates::RealState::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    LOWER(integration_real_states_real_states.descricao_imovel) LIKE LOWER(:search) OR
    LOWER(integration_real_states_real_states.municipio) LIKE LOWER(:search) OR
    LOWER(integration_real_states_real_states.numero_imovel) LIKE LOWER(:search) OR
    LOWER(integration_real_states_real_states.bairro) LIKE LOWER(:search) OR
    LOWER(integration_real_states_real_states.cep) LIKE LOWER(:search) OR
    LOWER(integration_real_states_real_states.endereco) LIKE LOWER(:search) OR
    LOWER(integration_real_states_real_states.complemento) LIKE LOWER(:search) OR
    LOWER(integration_real_states_real_states.lote) LIKE LOWER(:search) OR
    LOWER(integration_real_states_real_states.quadra) LIKE LOWER(:search)
  }
end
