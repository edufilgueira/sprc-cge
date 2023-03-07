FactoryBot.define do
  factory :integration_supports_product, class: 'Integration::Supports::Product' do
    sequence(:codigo) { |n| "#{n}" }
    sequence(:titulo) { |n| "Produto #{n}" }

    trait :invalid do
      codigo nil
      titulo nil
    end
  end
end
