require 'rails_helper'

describe Integration::Contracts::Contract::Search do

  let!(:contract) { create(:integration_contracts_contract, isn_sic: 999999) }
  let!(:another_contract) { create(:integration_contracts_contract, descricao_situacao: 'other') }

  it 'isn_sic' do
    contracts = Integration::Contracts::Contract.search(contract.isn_sic)
    expect(contracts).to eq([contract])
  end

  it 'num_contrato' do
    contracts = Integration::Contracts::Contract.search(contract.num_contrato)
    expect(contracts).to eq([contract])
  end

  it 'plain_num_contrato' do
    contracts = Integration::Contracts::Contract.search(contract.plain_num_contrato)
    expect(contracts).to eq([contract])
  end

  it 'descricao_objeto' do
    contracts = Integration::Contracts::Contract.search(contract.descricao_objeto)
    expect(contracts).to eq([contract])
  end

  # CPF/CNPJ do contratado
  it 'cpf_cnpj_financiador' do
    contracts = Integration::Contracts::Contract.search(contract.cpf_cnpj_financiador)
    expect(contracts).to eq([contract])
  end

  it 'sigla unidade' do
    organ = create(:integration_supports_organ, sigla: 'SDE', orgao_sfp: false)
    contract.manager = organ
    contract.save

    contracts = Integration::Contracts::Contract.search(contract.manager.sigla)
    expect(contracts).to eq([contract])
  end
end
