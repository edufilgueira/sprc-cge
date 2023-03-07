FactoryBot.define do
  factory :stats_results_strategic_indicator, class: 'Stats::Results::StrategicIndicator' do
    month { Date.today.month }
    year { Date.today.year }
    data {}
  end
end
