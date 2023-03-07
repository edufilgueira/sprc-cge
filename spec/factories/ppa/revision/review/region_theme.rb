
FactoryBot.define do
  factory :ppa_revision_review_region_theme, class: 'PPA::Revision::Review::RegionTheme' do

    association :theme, factory: :ppa_theme
    association :region, factory: :ppa_region
    problem_situation_strategy { PPA::Revision::Review::ProblemSituationStrategy.first || create(:ppa_revision_review_problem_situation_strategy) }


  end
end