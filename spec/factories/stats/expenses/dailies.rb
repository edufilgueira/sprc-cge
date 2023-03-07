FactoryBot.define do
  factory :stats_expenses_daily, class: 'Stats::Expenses::Daily' do
    month { Date.today.month }
    year { Date.today.year }
    data {}
  end
end
