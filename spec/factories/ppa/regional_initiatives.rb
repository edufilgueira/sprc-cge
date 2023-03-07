FactoryBot.define do
  factory :ppa_regional_initiative, class: 'PPA::RegionalInitiative' do

    association :initiative, factory: :ppa_initiative
    association :region,     factory: :ppa_region

    trait :invalid do
      initiative nil
      region nil
    end

  end
end
