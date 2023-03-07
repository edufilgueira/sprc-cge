FactoryBot.define do
  factory :stats_revenues_expenses, class: 'Stats::RevenueExpense' do
    month { Date.today.month }
    year { Date.today.year }
    data {}
  end
end
