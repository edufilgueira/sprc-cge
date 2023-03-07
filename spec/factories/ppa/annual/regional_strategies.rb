FactoryBot.define do
  factory :ppa_annual_regional_strategy, class: 'PPA::Annual::RegionalStrategy' do

    association :strategy, factory: :ppa_strategy
    association :region,   factory: :ppa_region

    year { Date.today.year }

    trait :invalid do
      strategy nil
      region nil
      year nil
    end

  end
end
