FactoryBot.define do
  factory :integration_eparcerias_transfer_bank_order, class: 'Integration::Eparcerias::TransferBankOrder' do
    isn_sic { convenant.isn_sic }
    association :convenant, factory: :integration_contracts_convenant

    sequence(:numero_ordem_bancaria)
    sequence(:tipo_ordem_bancaria)
    data_pagamento Date.today

    nome_benceficiario 'Beneficiário'

    valor_ordem_bancaria 123.46

    trait :invalid do
      numero_ordem_bancaria nil
    end
  end
end
