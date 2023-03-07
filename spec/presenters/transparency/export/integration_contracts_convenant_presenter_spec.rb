require 'rails_helper'

describe Transparency::Export::IntegrationContractsConvenantPresenter do
  subject(:convenant_spreadsheet_presenter) do
    Transparency::Export::IntegrationContractsConvenantPresenter.new(convenant)
  end

  let(:convenant) { create(:integration_contracts_contract, :convenio) }


  let(:klass) { Integration::Contracts::Convenant }

  it 'spreadsheet_header' do
    expected = [
      klass.human_attribute_name(:data_assinatura),
      klass.human_attribute_name(:data_termino),
      klass.human_attribute_name(:data_publicacao_portal),
      klass.human_attribute_name(:data_publicacao_doe),
      klass.human_attribute_name(:isn_sic),
      klass.human_attribute_name(:num_contrato),
      klass.human_attribute_name(:cod_plano_trabalho),
      klass.human_attribute_name(:cpf_cnpj_financiador),
      klass.human_attribute_name(:status_str),
      klass.human_attribute_name(:accountability_status),
      klass.human_attribute_name(:manager_title),
      klass.human_attribute_name(:grantor_title),
      klass.human_attribute_name(:creditor_title),
      klass.human_attribute_name(:descriaco_edital),
      klass.human_attribute_name(:descricao_situacao),
      klass.human_attribute_name(:decricao_modalidade),
      klass.human_attribute_name(:tipo_objeto),
      klass.human_attribute_name(:descricao_objeto),
      klass.human_attribute_name(:descricao_justificativa),
      klass.human_attribute_name(:valor_contrato),
      klass.human_attribute_name(:valor_can_rstpg),
      klass.human_attribute_name(:valor_original_concedente),
      klass.human_attribute_name(:valor_original_contrapartida),
      klass.human_attribute_name(:valor_atualizado_contrapartida),
      klass.human_attribute_name(:valor_atualizado_concedente),
      klass.human_attribute_name(:valor_atualizado_total),
      klass.human_attribute_name(:calculated_valor_empenhado),
      klass.human_attribute_name(:calculated_valor_pago)
    ]

    expect(Transparency::Export::IntegrationContractsConvenantPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      convenant.data_assinatura,
      convenant.data_termino,
      convenant.data_publicacao_portal,
      convenant.data_publicacao_doe,
      convenant.isn_sic,
      convenant.num_contrato,
      convenant.cod_plano_trabalho,
      convenant.cpf_cnpj_financiador,
      convenant.status_str,
      convenant.accountability_status,
      convenant.manager_title,
      convenant.grantor_title,
      convenant.creditor_title,
      convenant.descriaco_edital,
      convenant.descricao_situacao,
      convenant.decricao_modalidade,
      convenant.tipo_objeto,
      convenant.descricao_objeto,
      convenant.descricao_justificativa,
      convenant.valor_contrato,
      convenant.valor_can_rstpg,
      convenant.valor_original_concedente,
      convenant.valor_original_contrapartida,
      convenant.valor_atualizado_contrapartida,
      convenant.valor_atualizado_concedente,
      convenant.valor_atualizado_total,
      convenant.calculated_valor_empenhado,
      convenant.calculated_valor_pago
    ]

    result = convenant_spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
