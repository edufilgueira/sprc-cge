require 'rails_helper'

describe IntegrationExpensesHelper do

  it 'integration_expenses_cod_grupo_desp_for_select' do
    items = ['PES', 'MAN', 'PRI', 'FIN', 'TRA', 'SDD']

    expected = [[I18n.t('messages.filters.select.all.male'), ' ']] + items.map do |item|
      [Integration::Expenses::BudgetBalance.human_attribute_name("cod_grupo_desp.#{item}"), item]
    end.sort

    expect(integration_expenses_cod_grupo_desp_for_select).to eq(expected)
  end
end
