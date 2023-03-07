FactoryBot.define do
  factory :integration_supports_government_program, class: 'Integration::Supports::GovernmentProgram' do
    sequence(:ano_inicio) { |n| n }
    sequence(:codigo_programa) { |n| "#{n}" }
    sequence(:titulo) { |n| "Programa de Governo #{n}" }

    trait :invalid do
      ano_inicio nil
      codigo_programa nil
      titulo nil
    end
  end
end
