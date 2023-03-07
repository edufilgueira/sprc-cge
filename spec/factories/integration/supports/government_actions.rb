FactoryBot.define do
  factory :integration_supports_government_action, class: 'Integration::Supports::GovernmentAction' do
    sequence(:codigo_acao) { |n| "#{n}" }
    sequence(:titulo) { |n| "Programa de Governo #{n}" }

    trait :invalid do
      codigo_acao nil
      titulo nil
    end
  end
end
