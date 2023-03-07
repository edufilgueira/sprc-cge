require 'rails_helper'

describe Transparency::Export::IntegrationExpensesCityTransferPresenter do

  subject(:spreadsheet_presenter) do
    Transparency::Export::IntegrationExpensesCityTransferPresenter.new(city_transfer)
  end

  let(:organ) { create(:integration_supports_organ, orgao_sfp: false) }

  let(:city_transfer) { create(:integration_expenses_city_transfer) }

  let(:klass) { Integration::Expenses::CityTransfer }

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
    expected = columns.map{|column| I18n.t("integration/expenses/city_transfer.spreadsheet.worksheets.default.header.#{column}") }

    expect(Transparency::Export::IntegrationExpensesCityTransferPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      city_transfer.exercicio,
      I18n.l(city_transfer.date_of_issue),
      city_transfer.management_unit_title,
      city_transfer.budget_unit_title,
      city_transfer.executing_unit_title,
      city_transfer.creditor_nome,
      city_transfer.function_title,
      city_transfer.sub_function_title,
      city_transfer.government_program_title,
      city_transfer.government_action_title,
      city_transfer.administrative_region_title,
      city_transfer.expense_nature_title,
      city_transfer.resource_source_title,
      city_transfer.expense_type_title,
      city_transfer.valor,
      city_transfer.valor_pago,
      city_transfer.calculated_valor_final,
      city_transfer.calculated_valor_pago_final,
      city_transfer.calculated_valor_suplementado,
      city_transfer.calculated_valor_anulado,
      city_transfer.calculated_valor_pago_anulado
    ]

    result = spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
