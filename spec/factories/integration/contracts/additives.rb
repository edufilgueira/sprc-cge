FactoryBot.define do
  factory :integration_contracts_additive, class: 'Integration::Contracts::Additive' do
    descricao_observacao "Constitui objeto do presente Aditivo o acréscimo de R$100.00 "
    descricao_tipo_aditivo "Acrescimo"
    descricao_url "MyString"
    data_aditivo "2017-06-14 19:57:27"
    data_inicio "2017-06-14 19:57:27"
    data_publicacao "2017-06-14 19:57:27"
    data_termino "0001-01-01 00:00:00"
    flg_tipo_aditivo 50
    isn_contrato_aditivo 1
    isn_ig 1
    isn_sic { contract.isn_sic }
    valor_acrescimo "82694.20"
    valor_reducao "0"
    data_publicacao_portal "2017-06-14 19:57:27"
    num_aditivo_siconv "MyString"
    association :contract, factory: :integration_contracts_contract

    trait :invalid do
      data_aditivo nil
    end

    trait :extension do
      flg_tipo_aditivo 49
      valor_acrescimo 0
      data_termino { Date.current + 1.month }
    end

    trait :reduction do
      flg_tipo_aditivo 51
      valor_acrescimo 0
      valor_reducao 1500.00
    end

    trait :extension_addition do
      flg_tipo_aditivo 52
      data_termino { Date.current + 1.month }
    end
  end
end
