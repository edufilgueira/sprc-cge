FactoryBot.define do
  factory :integration_revenues_transfer, class: 'Integration::Revenues::Transfer' do
    conta_corrente "#{ Integration::Supports::RevenueNature::TRANSFER_CODES[:required].first }.10000"
    natureza_credito "DEBITO"
    valor_credito "799.01"
    natureza_debito "CRÉDITO"
    valor_debito 0.00
    valor_inicial 0
    natureza_inicial nil
    mes "2"
    association :revenue, factory: :integration_revenues_revenue

    trait :invalid do
      conta_corrente nil
    end
  end
end
