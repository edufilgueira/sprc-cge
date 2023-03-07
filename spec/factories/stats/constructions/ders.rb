FactoryBot.define do
  factory :stats_constructions_der, class: 'Stats::Constructions::Der' do
    month { Date.today.month }
    year { Date.today.year }
    data {}
  end
end
