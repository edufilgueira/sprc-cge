require 'rails_helper'

describe Transparency::RevenuesExpensesController do

  describe '#index' do

    it 'create new stats data' do
      revenues_stats = create(:stats_revenues_account, year: 2010, month_start: 1, month_end: 12, data: { total: { valor_arrecadado: 10 }})
      expenses_stats = create(:stats_expenses_budget_balance, year: 2010, month_start: 1, month_end: 12, data: { total: { calculated_valor_empenhado: 5 }})
      stats = create(:stats_revenues_expenses, year: 2010, month: Date.today.month - 1)

      get(:index, params: { stats_year: 2010 } )

      expect(controller.stats.id).to_not eq(stats.id)
      expect(controller.stats.year).to eq(2010)

      stats_data = controller.stats.data[:revenues_expenses]
      expect(stats_data['Receitas - Valor arrecadado'][:total]).to eq(10)
      expect(stats_data['Despesas - Valor empenhado'][:total]).to eq(5)
    end

    it 'find existent stats data' do
      revenues_stats = create(:stats_revenues_account, year: 2010, month_start: 1, month_end: 6, data: { total: { valor_arrecadado: 10 }})
      expenses_stats = create(:stats_expenses_budget_balance, year: 2010, month_start: 1, month_end: 6, data: { total: { calculated_valor_empenhado: 5 }})
      stats = create(:stats_revenues_expenses, year: 2010, month: 6)

      get(:index, params: { stats_year: 2010 } )

      expect(controller.stats.id).to eq(stats.id)
    end

    it 'empty when other year' do
      revenues_stats = create(:stats_revenues_account, year: 2010, month_start: 1, month_end: 12, data: { total: { valor_arrecadado: 10 }})
      expenses_stats = create(:stats_expenses_budget_balance, year: 2010, month_start: 1, month_end: 12, data: { total: { calculated_valor_empenhado: 5 }})
      get(:index, params: { stats_year: 2009 } )

      expect(controller.stats).to be_nil
      is_expected.to respond_with(:success)
    end
  end
end
