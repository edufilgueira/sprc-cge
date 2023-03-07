FactoryBot.define do
  factory :ppa_revision_review_problem_situation, class: 'PPA::Revision::Review::ProblemSituation' do

    association :problem_situation, factory: :ppa_problem_situation
    region_theme { PPA::Revision::Review::RegionTheme.first || create(:ppa_revision_review_region_theme) }
    
    persist true

  end
end