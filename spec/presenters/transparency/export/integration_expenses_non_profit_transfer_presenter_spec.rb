require 'rails_helper'

describe Transparency::Export::IntegrationExpensesNonProfitTransferPresenter do
  subject(:spreadsheet_presenter) do
    Transparency::Export::IntegrationExpensesNonProfitTransferPresenter.new(non_profit_transfer)
  end

  let(:organ) { create(:integration_supports_organ, orgao_sfp: false) }

  let(:non_profit_transfer) { create(:integration_expenses_non_profit_transfer) }

  let(:klass) { Integration::Expenses::NonProfitTransfer }

  let(:columns) do
    [
      :exercicio,
      :numero,
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
    expected = columns.map{|column| I18n.t("integration/expenses/non_profit_transfer.spreadsheet.worksheets.default.header.#{column}") }

    expect(Transparency::Export::IntegrationExpensesNonProfitTransferPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      non_profit_transfer.exercicio,
      non_profit_transfer.numero,
      I18n.l(non_profit_transfer.date_of_issue),
      non_profit_transfer.management_unit_title,
      non_profit_transfer.budget_unit_title,
      non_profit_transfer.executing_unit_title,
      non_profit_transfer.creditor_nome,
      non_profit_transfer.function_title,
      non_profit_transfer.sub_function_title,
      non_profit_transfer.government_program_title,
      non_profit_transfer.government_action_title,
      non_profit_transfer.administrative_region_title,
      non_profit_transfer.expense_nature_title,
      non_profit_transfer.resource_source_title,
      non_profit_transfer.expense_type_title,
      non_profit_transfer.valor,
      non_profit_transfer.valor_pago,
      non_profit_transfer.calculated_valor_final,
      non_profit_transfer.calculated_valor_pago_final,
      non_profit_transfer.calculated_valor_suplementado,
      non_profit_transfer.calculated_valor_anulado,
      non_profit_transfer.calculated_valor_pago_anulado
    ]

    result = spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
