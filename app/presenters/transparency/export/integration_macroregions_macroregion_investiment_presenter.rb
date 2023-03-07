class Transparency::Export::IntegrationMacroregionsMacroregionInvestimentPresenter < Transparency::Export::BasePresenter

  COLUMNS = [
    :ano_exercicio,
    :codigo_poder,
    :descricao_poder,
    :codigo_regiao,
    :descricao_regiao,
    :valor_lei,
    :valor_lei_creditos,
    :valor_empenhado,
    :valor_pago,
    :perc_empenho,
    :perc_pago_calculated
  ].freeze

  def self.spreadsheet_header_title(column)
    Integration::Macroregions::MacroregionInvestiment.human_attribute_name(column)
  end

  def self.columns
    COLUMNS
  end

  def columns
    self.class.columns
  end
end
