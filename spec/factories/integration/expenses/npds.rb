FactoryBot.define do
  factory :integration_expenses_npd, class: 'Integration::Expenses::Npd' do
    exercicio Date.today.year
    unidade_gestora "191011"
    unidade_executora "191011"
    sequence(:numero) { |n| "#{n}" }
    numero_npd_ordinaria ""
    codigo_localidade_npd_ordinaria ""
    codigo_retencao ""
    natureza "ORDINARIA"
    justificativa ""
    efeito ""
    numero_processo_administrativo_despesa ""
    data_emissao ""
    credor ""
    documento_credor ""
    valor "9.99"
    numero_nld_ordinaria "11"
    codigo_natureza_receita ""
    servico_bancario ""
    banco_origem ""
    agencia_origem ""
    digito_agencia_origem ""
    conta_origem ""
    digito_conta_origem ""
    banco_pagamento ""
    codigo_localidade ""
    banco_beneficiario ""
    agencia_beneficiario ""
    digito_agencia_beneficiario ""
    conta_beneficiario ""
    digito_conta_beneficiario ""
    status_movimento_bancario ""
    data_retorno_remessa_bancaria ""
    processo_judicial ""
    data_atual ""

    trait :invalid do
      exercicio nil
    end
  end
end
