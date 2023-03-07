FactoryBot.define do
  factory :stat do
    type 'Stats::Contracts::Contract'
    month { Date.today.month }
    year { Date.today.year }
    month_start { 1 }
    month_end { Date.today.month }
    data {}
  end
end
