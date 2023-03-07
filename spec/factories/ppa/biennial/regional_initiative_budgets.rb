FactoryBot.define do
  factory :ppa_biennial_regional_initiative_budget,
          parent: :ppa_biennial_measurement,
          class: 'PPA::Biennial::RegionalInitiativeBudget' do

    # association :regional_initiative, factory: :ppa_biennial_regional_initiative
    measures { build :ppa_biennial_regional_initiative }

  end
end
