FactoryBot.define do
  factory :stats_contracts_management_contract, class: 'Stats::Contracts::ManagementContract' do
    month { Date.today.month }
    year { Date.today.year }
    data {}
  end
end
