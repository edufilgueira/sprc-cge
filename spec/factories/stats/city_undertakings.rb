FactoryBot.define do
  factory :stats_city_undertaking, class: 'Stats::CityUndertaking' do
    month { Date.today.month }
    year { Date.today.year }
    data {}
  end
end
