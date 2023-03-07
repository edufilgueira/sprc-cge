FactoryBot.define do
  factory :stats_real_state, class: 'Stats::RealState' do
    month { Date.today.month }
    year { Date.today.year }
    data {}
  end
end
