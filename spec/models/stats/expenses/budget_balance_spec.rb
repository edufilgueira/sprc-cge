require 'rails_helper'

describe Stats::Expenses::BudgetBalance do

  subject(:stats_expenses_budget_balance) { build(:stats_expenses_budget_balance) }

  it_behaves_like 'models/base'
  it_behaves_like 'models/timestamp'

  context 'inheritance' do
    it { is_expected.to be_a(Stat) }
  end
end
