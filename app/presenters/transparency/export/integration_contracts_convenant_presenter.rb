class Transparency::Export::IntegrationContractsConvenantPresenter < Transparency::Export::BasePresenter

  COLUMNS = [
    :data_assinatura,
    :data_termino,
    :data_publicacao_portal,
    :data_publicacao_doe,    
    :isn_sic,
    :num_contrato,
    :cod_plano_trabalho,
    :cpf_cnpj_financiador,
    :status_str,
    :accountability_status,
    :manager_title,
    :grantor_title,
    :creditor_title,
    :descriaco_edital,
    :descricao_situacao,
    :decricao_modalidade,
    :tipo_objeto,
    :descricao_objeto,
    :descricao_justificativa,
    :valor_contrato,
    :valor_can_rstpg,
    :valor_original_concedente,
    :valor_original_contrapartida,
    :valor_atualizado_contrapartida,
    :valor_atualizado_concedente,
    :valor_atualizado_total,
    :calculated_valor_empenhado,
    :calculated_valor_pago
  ].freeze


  private

  def self.spreadsheet_header_title(column)
    Integration::Contracts::Convenant.human_attribute_name(column)
  end

  def self.columns
    COLUMNS
  end

  def columns
    self.class.columns
  end
end
