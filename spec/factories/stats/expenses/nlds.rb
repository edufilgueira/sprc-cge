FactoryBot.define do
  factory :stats_expenses_nld, class: 'Stats::Expenses::Nld' do
    month { Date.today.month }
    year { Date.today.year }
    data {}
  end
end
