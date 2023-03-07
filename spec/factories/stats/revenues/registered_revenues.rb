FactoryBot.define do
  factory :stats_revenues_registered_revenue, class: 'Stats::Revenues::RegisteredRevenue' do
    month { Date.today.month }
    year { Date.today.year }
    data {}
  end
end
