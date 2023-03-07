require 'rails_helper'

describe Transparency::Export::IntegrationExpensesConsortiumTransferPresenter do

  subject(:spreadsheet_presenter) do
    Transparency::Export::IntegrationExpensesConsortiumTransferPresenter.new(consortium_transfer)
  end

  let(:organ) { create(:integration_supports_organ, orgao_sfp: false) }

  let(:consortium_transfer) { create(:integration_expenses_consortium_transfer) }

  let(:klass) { Integration::Expenses::ConsortiumTransfer }

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
    expected = columns.map{|column| I18n.t("integration/expenses/consortium_transfer.spreadsheet.worksheets.default.header.#{column}") }

    expect(Transparency::Export::IntegrationExpensesConsortiumTransferPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      consortium_transfer.exercicio,
      I18n.l(consortium_transfer.date_of_issue),
      consortium_transfer.management_unit_title,
      consortium_transfer.budget_unit_title,
      consortium_transfer.executing_unit_title,
      consortium_transfer.creditor_nome,
      consortium_transfer.function_title,
      consortium_transfer.sub_function_title,
      consortium_transfer.government_program_title,
      consortium_transfer.government_action_title,
      consortium_transfer.administrative_region_title,
      consortium_transfer.expense_nature_title,
      consortium_transfer.resource_source_title,
      consortium_transfer.expense_type_title,
      consortium_transfer.valor,
      consortium_transfer.valor_pago,
      consortium_transfer.calculated_valor_final,
      consortium_transfer.calculated_valor_pago_final,
      consortium_transfer.calculated_valor_suplementado,
      consortium_transfer.calculated_valor_anulado,
      consortium_transfer.calculated_valor_pago_anulado
    ]

    result = spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
