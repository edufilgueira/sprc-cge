FactoryBot.define do
  factory :integration_supports_payment_retention_type, class: 'Integration::Supports::PaymentRetentionType' do
    sequence(:codigo_retencao) { |n| "#{n}" }
    sequence(:titulo) { |n| "Tipo de Retenção do Pagamento #{n}" }

    trait :invalid do
      codigo_retencao nil
      titulo nil
    end
  end
end
