FactoryBot.define do
  factory :stats_contracts_contract, class: 'Stats::Contracts::Contract' do
    month { Date.today.month }
    year { Date.today.year }
    data {}
  end
end
