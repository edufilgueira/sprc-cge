FactoryBot.define do
  factory :ppa_regional_product_goal,
          parent: :ppa_measurement,
          class: 'PPA::RegionalProductGoal' do

    # association :regional_product, factory: :ppa_regional_product
    measures { build :ppa_regional_product }

  end
end
