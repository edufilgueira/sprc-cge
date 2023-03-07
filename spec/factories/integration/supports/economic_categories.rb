FactoryBot.define do
  factory :integration_supports_economic_category, class: 'Integration::Supports::EconomicCategory' do
    sequence(:codigo_categoria_economica) { |n| "#{n}" }
    sequence(:titulo) { |n| "Categoria Economica #{n}" }

    trait :invalid do
      codigo_categoria_economica nil
      titulo nil
    end
  end
end
