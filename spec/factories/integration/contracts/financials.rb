FactoryBot.define do
  factory :integration_contracts_financial, class: 'Integration::Contracts::Financial' do
    ano_documento '2018'
    cod_entidade 1
    cod_fonte 1
    cod_gestor 1
    descricao_entidade "MyString"
    descricao_objeto "MyString"
    data_documento "2017-06-14 19:44:43"
    data_pagamento "2017-06-14 19:44:43"
    data_processamento "2017-06-14 19:44:43"
    flg_sic 1
    isn_sic { contract.isn_sic }
    num_pagamento "MyString"
    num_documento "MyString"
    valor_documento "9.99"
    valor_pagamento "9.99"
    cod_credor "MyString"
    association :contract, factory: :integration_contracts_contract

    trait :invalid do
      cod_entidade nil
    end
  end
end
