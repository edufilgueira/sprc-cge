FactoryBot.define do
  factory :stats_expenses_fund_supply, class: 'Stats::Expenses::FundSupply' do
    month { Date.today.month }
    year { Date.today.year }
    data {}
  end
end
