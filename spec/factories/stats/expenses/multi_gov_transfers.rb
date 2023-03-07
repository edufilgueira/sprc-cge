FactoryBot.define do
  factory :stats_expenses_multi_gov_transfer, class: 'Stats::Expenses::MultiGovTransfer' do
    month { Date.today.month }
    year { Date.today.year }
    data {}
  end
end
