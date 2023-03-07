FactoryBot.define do
  factory :stats_evaluation, class: 'Stats::Evaluation' do
    data ""
    evaluation_type 0
    month Date.today.month
    year Date.today.year
  end
end
