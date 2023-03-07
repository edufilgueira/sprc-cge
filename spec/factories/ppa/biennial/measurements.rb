FactoryBot.define do
  factory :ppa_biennial_measurement, class: 'PPA::Biennial::Measurement' do

    expected { rand(100_000.12) }
    actual   { rand(120_000.12) }

    # invalid
    trait :invalid do
      # period nil
      measures nil
    end

  end
end
