FactoryBot.define do
  factory :stats_expenses_ned, class: 'Stats::Expenses::Ned' do
    month { Date.today.month }
    year { Date.today.year }
    data {}

    initialize_with { Stats::Expenses::Ned.find_or_create_by(year: year, month: month) }
  end
end
