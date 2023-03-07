FactoryBot.define do
  factory :ppa_revision_review_regional_strategy, class: 'PPA::Revision::Review::RegionalStrategy' do

    association :strategy, factory: :ppa_strategy
    region_theme { PPA::Revision::Review::RegionTheme.first || create(:ppa_revision_review_region_theme) }

    persist true

  end
end