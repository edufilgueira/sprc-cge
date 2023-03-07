FactoryBot.define do
  factory :integration_macroregions_power, class: 'Integration::Macroregions::Power' do
    sequence(:code) { |n| "#{n}" }
    sequence(:name) { |n| "Poder - #{n}" }

    trait :invalid do
      name nil
    end
  end
end
