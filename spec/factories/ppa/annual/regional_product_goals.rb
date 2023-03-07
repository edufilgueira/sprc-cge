FactoryBot.define do
  factory :ppa_annual_regional_product_goal,
          parent: :ppa_annual_measurement,
          class: 'PPA::Annual::RegionalProductGoal' do

    # association :regional_product, factory: :ppa_annual_regional_product
    measures { build :ppa_annual_regional_product }

  end
end
