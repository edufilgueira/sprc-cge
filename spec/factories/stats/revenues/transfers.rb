FactoryBot.define do
  factory :stats_revenues_transfer, class: 'Stats::Revenues::Transfer' do
    month { Date.today.month }
    year { Date.today.year }
    data {}
  end
end
