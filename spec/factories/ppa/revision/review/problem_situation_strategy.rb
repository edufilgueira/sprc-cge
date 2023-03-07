
FactoryBot.define do
  factory :ppa_revision_review_problem_situation_strategy, class: 'PPA::Revision::Review::ProblemSituationStrategy' do

    plan  { PPA::Plan.first || create(:ppa_plan) }
    association :user, factory: :user

  end
end