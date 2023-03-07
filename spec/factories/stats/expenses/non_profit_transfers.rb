FactoryBot.define do
  factory :stats_expenses_non_profit_transfer, class: 'Stats::Expenses::NonProfitTransfer' do
    month { Date.today.month }
    year { Date.today.year }
    data {}
  end
end
