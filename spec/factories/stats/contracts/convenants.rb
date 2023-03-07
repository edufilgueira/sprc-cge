FactoryBot.define do
  factory :stats_contracts_convenant, class: 'Stats::Contracts::Convenant' do
    month { Date.today.month }
    year { Date.today.year }
    data {}
  end
end
