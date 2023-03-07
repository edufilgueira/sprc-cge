FactoryBot.define do
  factory :stats_revenues_account, class: 'Stats::Revenues::Account' do
    month { Date.today.month }
    year { Date.today.year }
    data {}
  end
end
