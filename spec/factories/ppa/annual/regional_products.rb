FactoryBot.define do
  factory :ppa_annual_regional_product, class: 'PPA::Annual::RegionalProduct' do

    association :product, factory: :ppa_product
    association :region,  factory: :ppa_region

    year { Date.today.year }

    trait :invalid do
      product nil
      region nil
    end
  end
end
