require 'rails_helper'

describe Transparency::Export::IntegrationContractsManagementContractPresenter do
  subject(:contract_spreadsheet_presenter) do
    Transparency::Export::IntegrationContractsManagementContractPresenter.new(contract)
  end

  let(:contract) { create(:integration_contracts_contract, :management) }

  let(:klass) { Integration::Contracts::ManagementContract }

  it 'spreadsheet_header' do
    expected = [
      klass.human_attribute_name(:data_assinatura),
      klass.human_attribute_name(:isn_sic),
      klass.human_attribute_name(:num_contrato),
      klass.human_attribute_name(:manager_title),
      klass.human_attribute_name(:grantor_title),
      klass.human_attribute_name(:descricao_nome_credor),
      klass.human_attribute_name(:descricao_situacao),
      klass.human_attribute_name(:decricao_modalidade),
      klass.human_attribute_name(:descricao_objeto),
      klass.human_attribute_name(:valor_atualizado_concedente),
      klass.human_attribute_name(:calculated_valor_empenhado),
      klass.human_attribute_name(:calculated_valor_pago)
    ]

    expect(Transparency::Export::IntegrationContractsManagementContractPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      contract.data_assinatura,
      contract.isn_sic,
      contract.num_contrato,
      contract.manager_title,
      contract.grantor_title,
      contract.descricao_nome_credor,
      contract.descricao_situacao,
      contract.decricao_modalidade,
      contract.descricao_objeto,
      contract.valor_atualizado_concedente,
      contract.calculated_valor_empenhado,
      contract.calculated_valor_pago
    ]

    result = contract_spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
