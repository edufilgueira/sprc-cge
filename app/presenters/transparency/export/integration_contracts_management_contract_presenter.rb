class Transparency::Export::IntegrationContractsManagementContractPresenter < Transparency::Export::BasePresenter

  COLUMNS = [
    :data_assinatura,
    :isn_sic,
    :num_contrato,
    :manager_title,
    :grantor_title,
    :descricao_nome_credor,
    :descricao_situacao,
    :decricao_modalidade,
    :descricao_objeto,
    :valor_atualizado_concedente,
    :calculated_valor_empenhado,
    :calculated_valor_pago
  ].freeze


  private

  def self.spreadsheet_header_title(column)
    Integration::Contracts::ManagementContract.human_attribute_name(column)
  end

  def self.columns
    COLUMNS
  end

  def columns
    self.class.columns
  end
end
