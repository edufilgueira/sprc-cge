FactoryBot.define do
  factory :ppa_annual_measurement, class: 'PPA::Annual::Measurement' do

    period   { PPA::Annual::Measurement.periods.keys.sample }
    expected { rand(100_000.12) }
    actual   { rand(120_000.12) }

    # traits for enum period
    PPA::Annual::Measurement.periods.each_pair do |period_key, period_val|
      trait period_key.to_sym do
        period period_val
      end
    end

    # invalid
    trait :invalid do
      # period nil
      measures nil
    end

  end
end
