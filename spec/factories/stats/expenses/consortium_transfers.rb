FactoryBot.define do
  factory :stats_expenses_consortium_transfer, class: 'Stats::Expenses::ConsortiumTransfer' do
    month { Date.today.month }
    year { Date.today.year }
    data {}
  end
end
