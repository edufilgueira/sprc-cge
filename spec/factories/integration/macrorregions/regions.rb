FactoryBot.define do
  factory :integration_macroregions_region, class: 'Integration::Macroregions::Region' do
    sequence(:code) { |n| "#{n}" }
    sequence(:name) { |n| "Macrorregiao - #{n}" }

    trait :invalid do
      name nil
    end
  end
end
