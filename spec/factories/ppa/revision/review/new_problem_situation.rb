FactoryBot.define do
  factory :ppa_revision_review_new_problem_situation, class: 'PPA::Revision::Review::NewProblemSituation' do

    association :city, factory: :ppa_city
    region_theme { PPA::Revision::Review::RegionTheme.first || create(:ppa_revision_review_region_theme) }
    description { 'Descrição de nova situação problema' }

  end
end