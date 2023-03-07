FactoryBot.define do
  factory :integration_supports_qualified_resource_source, class: 'Integration::Supports::QualifiedResourceSource' do
    sequence(:codigo) { |n| "#{n}" }
    sequence(:titulo) { |n| "Fonte de Recurso #{n}" }

    trait :invalid do
      codigo nil
      titulo nil
    end
  end
end
