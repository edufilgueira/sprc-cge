FactoryBot.define do
  factory :integration_supports_resource_source, class: 'Integration::Supports::ResourceSource' do
    sequence(:codigo_fonte) { |n| "#{n}" }
    sequence(:titulo) { |n| "Fonte de Recurso #{n}" }

    trait :invalid do
      titulo nil
    end
  end
end
