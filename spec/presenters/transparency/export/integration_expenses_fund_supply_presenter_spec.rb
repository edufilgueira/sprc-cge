require 'rails_helper'

describe Transparency::Export::IntegrationExpensesFundSupplyPresenter do

  subject(:spreadsheet_presenter) do
    Transparency::Export::IntegrationExpensesFundSupplyPresenter.new(fund_supply)
  end

  let(:organ) { create(:integration_supports_organ, orgao_sfp: false) }

  let(:fund_supply) { create(:integration_expenses_fund_supply) }

  let(:klass) { Integration::Expenses::FundSupply }

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

      :calculated_valor_final,
      :calculated_valor_pago_final,
      :calculated_valor_suplementado,
      :calculated_valor_anulado,
      :calculated_valor_pago_anulado
    ]
  end

  it 'spreadsheet_header' do
    expected = columns.map{|column| I18n.t("integration/expenses/fund_supply.spreadsheet.worksheets.default.header.#{column}") }

    expect(Transparency::Export::IntegrationExpensesFundSupplyPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      fund_supply.exercicio,
      I18n.l(fund_supply.date_of_issue),
      fund_supply.management_unit_title,
      fund_supply.budget_unit_title,
      fund_supply.executing_unit_title,
      fund_supply.creditor_nome,
      fund_supply.function_title,
      fund_supply.sub_function_title,
      fund_supply.government_program_title,
      fund_supply.government_action_title,
      fund_supply.administrative_region_title,
      fund_supply.expense_nature_title,
      fund_supply.resource_source_title,
      fund_supply.expense_type_title,
      fund_supply.calculated_valor_final,
      fund_supply.calculated_valor_pago_final,
      fund_supply.calculated_valor_suplementado,
      fund_supply.calculated_valor_anulado,
      fund_supply.calculated_valor_pago_anulado
    ]

    result = spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end

end
