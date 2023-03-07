FactoryBot.define do
  factory :stats_macroregian_investment, class: 'Stats::MacroregionInvestment' do
    month { Date.today.month }
    year { Date.today.year }
    data {}
  end
end
