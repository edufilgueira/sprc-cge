require 'rails_helper'

describe Transparency::Export::IntegrationRealStatesRealStatePresenter do
  subject(:real_state_spreadsheet_presenter) do
    Transparency::Export::IntegrationRealStatesRealStatePresenter.new(real_state)
  end

  let(:real_state) { create(:integration_real_states_real_state) }

  let(:klass) { Integration::RealStates::RealState }

  it 'spreadsheet_header' do
    expected = [
      klass.human_attribute_name(:service_id),
      klass.human_attribute_name(:descricao_imovel),
      klass.human_attribute_name(:property_type_title),
      klass.human_attribute_name(:occupation_type_title),
      klass.human_attribute_name(:estado),
      klass.human_attribute_name(:municipio),
      klass.human_attribute_name(:area_projecao_construcao),
      klass.human_attribute_name(:area_medida_in_loco),
      klass.human_attribute_name(:area_registrada),
      klass.human_attribute_name(:frente),
      klass.human_attribute_name(:fundo),
      klass.human_attribute_name(:lateral_direita),
      klass.human_attribute_name(:lateral_esquerda),
      klass.human_attribute_name(:taxa_ocupacao),
      klass.human_attribute_name(:fracao_ideal),
      klass.human_attribute_name(:numero_imovel),
      klass.human_attribute_name(:utm_zona),
      klass.human_attribute_name(:bairro),
      klass.human_attribute_name(:cep),
      klass.human_attribute_name(:endereco),
      klass.human_attribute_name(:complemento),
      klass.human_attribute_name(:lote),
      klass.human_attribute_name(:quadra)
    ]

    expect(Transparency::Export::IntegrationRealStatesRealStatePresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      real_state.service_id,
      real_state.descricao_imovel,
      real_state.property_type_title,
      real_state.occupation_type_title,
      real_state.estado,
      real_state.municipio,
      real_state.area_projecao_construcao,
      real_state.area_medida_in_loco,
      real_state.area_registrada,
      real_state.frente,
      real_state.fundo,
      real_state.lateral_direita,
      real_state.lateral_esquerda,
      real_state.taxa_ocupacao,
      real_state.fracao_ideal,
      real_state.numero_imovel,
      real_state.utm_zona,
      real_state.bairro,
      real_state.cep,
      real_state.endereco,
      real_state.complemento,
      real_state.lote,
      real_state.quadra
    ]

    result = real_state_spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
