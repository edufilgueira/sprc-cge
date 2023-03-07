FactoryBot.define do
  factory :ppa_regional_initiative_budget,
          parent: :ppa_measurement,
          class: 'PPA::RegionalInitiativeBudget' do

    # association :regional_initiative, factory: :ppa_regional_initiative
    measures { build :ppa_regional_initiative }

  end
end
