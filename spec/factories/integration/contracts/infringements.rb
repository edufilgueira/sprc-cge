FactoryBot.define do
  factory :integration_contracts_infringement, class: 'Integration::Contracts::Infringement' do
    cod_financiador "MyString"
    cod_gestora "MyString"
    descricao_entidade "MyString"
    descricao_financiador "MyString"
    descricao_motivo_inadimplencia "MyString"
    data_lancamento "2017-06-14 19:51:48"
    data_processamento "2017-06-14 19:51:48"
    data_termino_atual "2017-06-14 19:51:48"
    data_ultima_pcontas "2017-06-14 19:51:48"
    data_ultima_pagto "2017-06-14 19:51:48"
    isn_sic { contract.isn_sic }
    qtd_pagtos 1
    valor_atualizado_total "9.99"
    valor_inadimplencia "9.99"
    valor_liberacoes "9.99"
    valor_pcontas_acomprovar "9.99"
    valor_pcontas_apresentada "9.99"
    valor_pcontas_aprovada "9.99"
    association :contract, factory: :integration_contracts_contract

    trait :invalid do
      data_lancamento nil
    end
  end
end
