FactoryBot.define do
  factory :integration_supports_application_modality, class: 'Integration::Supports::ApplicationModality' do
    sequence(:codigo_modalidade) { |n| "#{n}" }
    sequence(:titulo) { |n| "Modalidade de Aplicação #{n}" }

    trait :invalid do
      codigo_modalidade nil
      titulo nil
    end
  end
end
