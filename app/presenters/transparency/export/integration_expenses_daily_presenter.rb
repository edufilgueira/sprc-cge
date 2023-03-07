class Transparency::Export::IntegrationExpensesDailyPresenter < Transparency::Export::BasePresenter

  COLUMNS = [
    :exercicio,
    :numero,
    :date_of_issue,
    :management_unit_title,
    :executing_unit_title,
    :creditor_nome,
    :calculated_valor_final
  ].freeze

  private

  def self.spreadsheet_header_title(column)
    I18n.t("integration/expenses/daily.spreadsheet.worksheets.default.header.#{column}")
  end

  def valor
    daily.valor_final
  end

  def self.columns
    COLUMNS
  end

  def columns
    self.class.columns
  end
end
