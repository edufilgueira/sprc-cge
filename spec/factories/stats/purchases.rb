FactoryBot.define do
  factory :stats_purchase, class: 'Stats::Purchase' do
    month { Date.today.month }
    year { Date.today.year }
    data {}
  end
end
