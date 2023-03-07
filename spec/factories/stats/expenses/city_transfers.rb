FactoryBot.define do
  factory :stats_expenses_city_transfer, class: 'Stats::Expenses::CityTransfer' do
    month { Date.today.month }
    year { Date.today.year }
    data {}

    initialize_with { Stats::Expenses::CityTransfer.find_or_create_by(year: year, month: month) }
  end
end
