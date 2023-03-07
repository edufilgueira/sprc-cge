require 'rails_helper'

describe Transparency::Export::IntegrationContractsContractPresenter do
  subject(:contract_spreadsheet_presenter) do
    Transparency::Export::IntegrationContractsContractPresenter.new(contract)
  end

  let(:contract) { create(:integration_contracts_contract, :contrato) }

  let(:klass) { Integration::Contracts::Contract }

  it 'spreadsheet_header' do
    expected = [
      klass.human_attribute_name(:data_assinatura),
      klass.human_attribute_name(:data_termino_original),
      klass.human_attribute_name(:data_termino),
      klass.human_attribute_name(:data_rescisao),
      klass.human_attribute_name(:data_publicacao_doe),
      klass.human_attribute_name(:isn_sic),
      klass.human_attribute_name(:num_contrato),
      klass.human_attribute_name(:num_spu),
      klass.human_attribute_name(:cpf_cnpj_financiador),
      klass.human_attribute_name(:manager_title),
      klass.human_attribute_name(:grantor_title),
      klass.human_attribute_name(:creditor_title),
      klass.human_attribute_name(:status_str),
      klass.human_attribute_name(:descricao_situacao),
      klass.human_attribute_name(:decricao_modalidade),
      klass.human_attribute_name(:tipo_objeto),
      klass.human_attribute_name(:descricao_objeto),
      klass.human_attribute_name(:descricao_justificativa),
      klass.human_attribute_name(:valor_contrato),
      klass.human_attribute_name(:calculated_valor_aditivo),
      klass.human_attribute_name(:valor_atualizado_concedente),
      klass.human_attribute_name(:calculated_valor_empenhado),
      klass.human_attribute_name(:calculated_valor_pago)
    ]

    expect(Transparency::Export::IntegrationContractsContractPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      contract.data_assinatura,
      contract.data_termino_original,
      contract.data_termino,
      contract.data_rescisao,
      contract.data_publicacao_doe,
      contract.isn_sic,
      contract.num_contrato,
      contract.num_spu,
      contract.cpf_cnpj_financiador,
      contract.manager_title,
      contract.grantor_title,
      contract.creditor_title,
      contract.status_str,
      contract.descricao_situacao,
      contract.decricao_modalidade,
      contract.tipo_objeto,
      contract.descricao_objeto,
      contract.descricao_justificativa,
      contract.valor_contrato,
      contract.calculated_valor_aditivo,
      contract.valor_atualizado_concedente,
      contract.calculated_valor_empenhado,
      contract.calculated_valor_pago,
    ]

    result = contract_spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
