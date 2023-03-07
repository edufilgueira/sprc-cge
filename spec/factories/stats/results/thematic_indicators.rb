FactoryBot.define do
  factory :stats_results_thematic_indicator, class: 'Stats::Results::ThematicIndicator' do
    month { Date.today.month }
    year { Date.today.year }
    data {}
  end
end
