FactoryBot.define do
  factory :stats_expenses_budget_balance, class: 'Stats::Expenses::BudgetBalance' do
    month { Date.today.month }
    year { Date.today.year }
    data {}
  end
end
