FactoryBot.define do
  factory :stats_expenses_profit_transfer, class: 'Stats::Expenses::ProfitTransfer' do
    month { Date.today.month }
    year { Date.today.year }
    data {}
  end
end
