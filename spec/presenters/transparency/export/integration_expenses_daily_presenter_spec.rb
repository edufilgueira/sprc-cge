require 'rails_helper'

describe Transparency::Export::IntegrationExpensesDailyPresenter do
  subject(:daily_spreadsheet_presenter) do
    Transparency::Export::IntegrationExpensesDailyPresenter.new(daily)
  end

  let(:daily) { create(:integration_expenses_daily) }

  let(:klass) { Integration::Expenses::Daily }

  it 'spreadsheet_header' do
    columns = [
      :exercicio,
      :numero,
      :date_of_issue,
      :management_unit_title,
      :executing_unit_title,
      :creditor_nome,
      :calculated_valor_final
    ]

    expected = columns.map{|column| I18n.t("integration/expenses/daily.spreadsheet.worksheets.default.header.#{column}") }

    expect(Transparency::Export::IntegrationExpensesDailyPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      daily.exercicio,
      daily.numero,
      daily.date_of_issue,
      daily.management_unit_title,
      daily.executing_unit_title,
      daily.creditor_nome,
      daily.calculated_valor_final
    ]

    result = daily_spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
