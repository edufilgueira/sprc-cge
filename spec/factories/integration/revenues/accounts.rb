FactoryBot.define do
  factory :integration_revenues_account, class: 'Integration::Revenues::Account' do
    conta_corrente "911130262.10000"
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
