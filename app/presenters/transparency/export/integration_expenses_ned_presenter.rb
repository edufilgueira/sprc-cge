class Transparency::Export::IntegrationExpensesNedPresenter < Transparency::Export::BasePresenter

  COLUMNS = [
    :exercicio,
    :numero,
    :date_of_issue,
    :management_unit_title,
    :executing_unit_title,
    :budget_unit_title,
    :razao_social_credor,

    :function_title,
    :sub_function_title,
    :government_program_title,
    :government_action_title,
    :administrative_region_title,
    :expense_nature_title,
    :resource_source_title,
    :expense_type_title,

    :valor,
    :valor_pago,

    :calculated_valor_final,
    :calculated_valor_pago_final,
    :calculated_valor_suplementado,
    :calculated_valor_anulado,
    :calculated_valor_pago_anulado
  ].freeze

  private

  def self.spreadsheet_header_title(column)
    I18n.t("integration/expenses/ned.spreadsheet.worksheets.default.header.#{column}")
  end

  def self.columns
    COLUMNS
  end

  def columns
    self.class.columns
  end
end
