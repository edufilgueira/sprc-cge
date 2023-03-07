FactoryBot.define do
  factory :ppa_regional_product, class: 'PPA::RegionalProduct' do

    association :product, factory: :ppa_product
    association :region,  factory: :ppa_region

    trait :invalid do
      product nil
      region nil
    end

  end
end
