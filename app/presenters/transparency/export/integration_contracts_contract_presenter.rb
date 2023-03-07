class Transparency::Export::IntegrationContractsContractPresenter < Transparency::Export::BasePresenter

  COLUMNS = [
    :data_assinatura,
    :data_termino_original,
    :data_termino,
    :data_rescisao,
    :data_publicacao_doe,
    :isn_sic,
    :num_contrato,
    :num_spu,
    :cpf_cnpj_financiador,
    :manager_title,
    :grantor_title,
    :creditor_title,
    :status_str,
    :descricao_situacao,
    :decricao_modalidade,
    :tipo_objeto,
    :descricao_objeto,
    :descricao_justificativa,
    :valor_contrato,
    :calculated_valor_aditivo,
    :valor_atualizado_concedente,
    :calculated_valor_empenhado,
    :calculated_valor_pago,

  ].freeze


  private

  def self.spreadsheet_header_title(column)
    Integration::Contracts::Contract.human_attribute_name(column)
  end

  def self.columns
    COLUMNS
  end

  def columns
    self.class.columns
  end
end
