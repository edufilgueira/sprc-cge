require 'rails_helper'

describe Integration::RealStates::RealState::Search do

  let!(:real_state) do
    create(:integration_real_states_real_state,
      descricao_imovel: 'DESC DO IMOVEL',
      municipio: 'NOVO MUNICIPIO',
      numero_imovel: 12345,
      bairro:'BAIRRO CAIENA',
      cep: '13456-789',
      endereco: 'RUA CAIENA',
      complemento: 'SALA 12',
      lote: 'LOTE 243',
      quadra: 'QUADRA 678'
    )
  end

  let!(:another_real_state) { create(:integration_real_states_real_state) }

  it 'descricao_imovel' do
    real_states = Integration::RealStates::RealState.search(real_state.descricao_imovel)
    expect(real_states).to eq([real_state])
  end

  it 'municipio' do
    real_states = Integration::RealStates::RealState.search(real_state.municipio)
    expect(real_states).to eq([real_state])
  end

  it 'numero_imovel' do
    real_states = Integration::RealStates::RealState.search(real_state.numero_imovel)
    expect(real_states).to eq([real_state])
  end

  it 'bairro' do
    real_states = Integration::RealStates::RealState.search(real_state.bairro)
    expect(real_states).to eq([real_state])
  end

  it 'cep' do
    real_states = Integration::RealStates::RealState.search(real_state.cep)
    expect(real_states).to eq([real_state])
  end

  it 'endereco' do
    real_states = Integration::RealStates::RealState.search(real_state.endereco)
    expect(real_states).to eq([real_state])
  end

  it 'complemento' do
    real_states = Integration::RealStates::RealState.search(real_state.complemento)
    expect(real_states).to eq([real_state])
  end

  it 'complemento' do
    real_states = Integration::RealStates::RealState.search(real_state.complemento)
    expect(real_states).to eq([real_state])
  end

  it 'lote' do
    real_states = Integration::RealStates::RealState.search(real_state.lote)
    expect(real_states).to eq([real_state])
  end

  it 'quadra' do
    real_states = Integration::RealStates::RealState.search(real_state.quadra)
    expect(real_states).to eq([real_state])
  end
end
