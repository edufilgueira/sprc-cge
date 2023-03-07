FactoryBot.define do
  factory :ppa_biennial_regional_product, class: 'PPA::Biennial::RegionalProduct' do

    association :product, factory: :ppa_product
    association :region,  factory: :ppa_region

    start_year { Date.today.year }
    end_year   { start_year.present? ? start_year + 1 : nil }

    trait :invalid do
      product nil
      region nil
      start_year nil
    end

  end
end
