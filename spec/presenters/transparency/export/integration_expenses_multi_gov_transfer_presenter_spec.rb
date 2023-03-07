require 'rails_helper'

describe Transparency::Export::IntegrationExpensesMultiGovTransferPresenter do

  subject(:spreadsheet_presenter) do
    Transparency::Export::IntegrationExpensesMultiGovTransferPresenter.new(multi_gov_transfer)
  end

  let(:organ) { create(:integration_supports_organ, orgao_sfp: false) }

  let(:multi_gov_transfer) { create(:integration_expenses_multi_gov_transfer) }

  let(:klass) { Integration::Expenses::MultiGovTransfer }

  let(:columns) do
    [
      :exercicio,
      :date_of_issue,
      :management_unit_title,
      :executing_unit_title,
      :budget_unit_title,
      :creditor_nome,

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
  end

  it 'spreadsheet_header' do
    expected = columns.map{|column| I18n.t("integration/expenses/multi_gov_transfer.spreadsheet.worksheets.default.header.#{column}") }

    expect(Transparency::Export::IntegrationExpensesMultiGovTransferPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      multi_gov_transfer.exercicio,
      I18n.l(multi_gov_transfer.date_of_issue),
      multi_gov_transfer.management_unit_title,
      multi_gov_transfer.budget_unit_title,
      multi_gov_transfer.executing_unit_title,
      multi_gov_transfer.creditor_nome,
      multi_gov_transfer.function_title,
      multi_gov_transfer.sub_function_title,
      multi_gov_transfer.government_program_title,
      multi_gov_transfer.government_action_title,
      multi_gov_transfer.administrative_region_title,
      multi_gov_transfer.expense_nature_title,
      multi_gov_transfer.resource_source_title,
      multi_gov_transfer.expense_type_title,
      multi_gov_transfer.valor,
      multi_gov_transfer.valor_pago,
      multi_gov_transfer.calculated_valor_final,
      multi_gov_transfer.calculated_valor_pago_final,
      multi_gov_transfer.calculated_valor_suplementado,
      multi_gov_transfer.calculated_valor_anulado,
      multi_gov_transfer.calculated_valor_pago_anulado
    ]

    result = spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
