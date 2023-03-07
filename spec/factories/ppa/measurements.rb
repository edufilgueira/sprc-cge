FactoryBot.define do
  factory :ppa_measurement, class: 'PPA::Measurement' do

    expected { rand(100_000.12) }
    actual   { rand(120_000.12) }

    # invalid
    trait :invalid do
      measures nil
      expected 0
      actual 0
    end

  end
end
