FactoryBot.define do
  factory :stats_expenses_npd, class: 'Stats::Expenses::Npd' do
    month { Date.today.month }
    year { Date.today.year }
    data {}
  end
end
