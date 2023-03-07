FactoryBot.define do
  factory :stats_expenses_npf, class: 'Stats::Expenses::Npf' do
    month { Date.today.month }
    year { Date.today.year }
    data {}
  end
end
