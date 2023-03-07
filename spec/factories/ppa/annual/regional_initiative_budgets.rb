FactoryBot.define do
  factory :ppa_annual_regional_initiative_budget,
          parent: :ppa_annual_measurement,
          class: 'PPA::Annual::RegionalInitiativeBudget' do

    # association :regional_initiative, factory: :ppa_annual_regional_initiative
    measures { build :ppa_annual_regional_initiative }

  end
end
