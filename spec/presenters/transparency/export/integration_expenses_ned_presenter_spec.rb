require 'rails_helper'

describe Transparency::Export::IntegrationExpensesNedPresenter do
  subject(:ned_spreadsheet_presenter) do
    Transparency::Export::IntegrationExpensesNedPresenter.new(ned)
  end

  let(:ned) { create(:integration_expenses_ned) }

  let(:klass) { Integration::Expenses::Ned }

  it 'spreadsheet_header' do
    columns = [
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
    ]

    expected = columns.map{|column| I18n.t("integration/expenses/ned.spreadsheet.worksheets.default.header.#{column}") }

    expect(Transparency::Export::IntegrationExpensesNedPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      ned.exercicio,
      ned.numero,
      ned.date_of_issue,
      ned.management_unit_title,
      ned.executing_unit_title,
      ned.budget_unit_title,
      ned.razao_social_credor,
      ned.function_title,
      ned.sub_function_title,
      ned.government_program_title,
      ned.government_action_title,
      ned.administrative_region_title,
      ned.expense_nature_title,
      ned.resource_source_title,
      ned.expense_type_title,
      ned.valor,
      ned.valor_pago,
      ned.calculated_valor_final,
      ned.calculated_valor_pago_final,
      ned.calculated_valor_suplementado,
      ned.calculated_valor_anulado,
      ned.calculated_valor_pago_anulado
    ]

    result = ned_spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
