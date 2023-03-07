FactoryBot.define do
  factory :integration_supports_function, class: 'Integration::Supports::Function' do
    sequence(:codigo_funcao) { |n| "#{n}" }
    sequence(:titulo) { |n| "Função #{n}" }

    trait :invalid do
      codigo_funcao nil
      titulo nil
    end
  end
end
