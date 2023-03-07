FactoryBot.define do
  factory :integration_supports_legal_device, class: 'Integration::Supports::LegalDevice' do
    sequence(:codigo) { |n| "#{n}" }
    sequence(:descricao) { |n| "Dispositivo Legal #{n}" }

    trait :invalid do
      codigo nil
      descricao nil
    end
  end
end
