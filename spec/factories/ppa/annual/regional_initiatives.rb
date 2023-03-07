FactoryBot.define do
  factory :ppa_annual_regional_initiative, class: 'PPA::Annual::RegionalInitiative' do

    association :initiative, factory: :ppa_initiative
    association :region,     factory: :ppa_region

    year { Date.today.year }

    trait :invalid do
      initiative nil
      region nil
    end

  end
end
