FactoryBot.define do
  factory :stats_constructions_dae, class: 'Stats::Constructions::Dae' do
    month { Date.today.month }
    year { Date.today.year }
    data {}
  end
end
