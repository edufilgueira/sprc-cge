FactoryBot.define do
  factory :integration_expenses_daily, class: 'Integration::Expenses::Daily' do
    exercicio Date.today.year
    sequence(:unidade_gestora) { |n| "40#{n}1" }
    unidade_executora "191011"
    sequence(:numero) { |n| "#{n}" }
    numero_npd_ordinaria ""
    codigo_localidade_npd_ordinaria ""
    numero_nld_ordinaria "1"
    codigo_retencao ""
    natureza "ORDINARIA"
    justificativa ""
    efeito ""
    numero_processo_administrativo_despesa ""
    data_emissao "28/10/#{Date.today.year}"
    credor ""
    documento_credor ""
    valor "9.99"
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

    after(:build) do |daily|
      # importante ter 339014 na posição correta
      # (integration_expenses_neds.exercicio < 2016 AND substring(integration_expenses_neds.classificacao_orcamentaria_completo from 29 for 6) in ('339014','339015','339092','449014','449015','449092')) OR
      # (integration_expenses_neds.exercicio >= 2016 AND substring(integration_expenses_neds.classificacao_orcamentaria_completo from 24 for 6) in ('339014','339015','339092','449014','449015','449092'))

      ned = create(:integration_expenses_ned, classificacao_orcamentaria_completo: "10100002061220032238703339014001000003000", unidade_gestora: daily.unidade_gestora)
      nld = create(:integration_expenses_nld, numero_nota_empenho_despesa: ned.numero, exercicio_restos_a_pagar: ned.exercicio, unidade_gestora: ned.unidade_gestora, exercicio: daily.exercicio, composed_key: ned.composed_key)

      create(:integration_supports_management_unit, codigo: ned.unidade_gestora)

      daily.unidade_gestora = nld.unidade_gestora
      daily.exercicio = nld.exercicio
      daily.numero_nld_ordinaria = nld.numero
    end

    trait :invalid do
      after(:build) do |daily|
        daily.exercicio = nil
      end
    end
  end
end
