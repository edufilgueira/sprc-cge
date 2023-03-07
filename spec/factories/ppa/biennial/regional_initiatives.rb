FactoryBot.define do
  factory :ppa_biennial_regional_initiative, class: 'PPA::Biennial::RegionalInitiative' do

    association :initiative, factory: :ppa_initiative
    association :region,     factory: :ppa_region

    start_year { Date.today.year }
    end_year   { start_year.present? ? start_year + 1 : nil }

    sequence(:name) { |n| "Biennial Regional Initiative #{n}" }


    trait :invalid do
      initiative nil
      region nil
      start_year nil
    end

  end
end
