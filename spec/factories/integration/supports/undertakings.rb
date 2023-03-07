FactoryBot.define do
  factory :integration_supports_undertaking, class: 'Integration::Supports::Undertaking' do
    sequence(:descricao) { |s| "RODOVIAS DO PROGRAMA CEARÁ #{s}" }

    trait :invalid do
      descricao nil
    end
  end
end
