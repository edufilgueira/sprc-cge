class Transparency::Export::IntegrationPurchasesPurchasePresenter < Transparency::Export::BasePresenter

  COLUMNS = [
    :numero_publicacao,
    :nome_resp_compra,
    :nome_fornecedor,
    :descricao_item,
    :quantidade_estimada,
    :valor_unitario,
    :valor_total_calculated
  ].freeze

  private

  def self.spreadsheet_header_title(column)
    Integration::Purchases::Purchase.human_attribute_name(column)
  end

  def self.columns
    COLUMNS
  end

  def columns
    self.class.columns
  end
end
