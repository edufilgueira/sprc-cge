FactoryBot.define do
  factory :ppa_biennial_regional_product_goal,
          parent: :ppa_biennial_measurement,
          class: 'PPA::Biennial::RegionalProductGoal' do

    # association :regional_product, factory: :ppa_biennial_regional_product
    measures { build :ppa_biennial_regional_product }

  end
end
