FactoryBot.define do
  factory :ppa_revision_review_new_regional_strategy, class: 'PPA::Revision::Review::NewRegionalStrategy' do

    region_theme { PPA::Revision::Review::RegionTheme.first || create(:ppa_revision_review_region_theme) }
    description { 'Descrição de nova estrategia regional' }

  end
end