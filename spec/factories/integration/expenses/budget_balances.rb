FactoryBot.define do
  factory :integration_expenses_budget_balance, class: 'Integration::Expenses::BudgetBalance' do
    data_atual "16/05/2018"
    ano_mes_competencia "07-2017"
    cod_unid_gestora "010001"
    cod_unid_orcam "01100001"
    cod_funcao "01"
    cod_subfuncao "031"
    cod_programa "051"
    cod_acao "22431"
    cod_localizacao_gasto "15"
    cod_natureza_desp "33903300"
    cod_fonte "10000"
    id_uso "0"
    cod_grupo_desp "MAN"
    cod_tp_orcam "1"
    cod_esfera_orcam "1"
    cod_grupo_fin "13"
    classif_orcam_reduz "2"
    classif_orcam_completa "01100001010310512243115339033001000002000"
    valor_inicial "0.00"
    valor_suplementado "0.00"
    valor_anulado "0.00"
    valor_transferido_recebido "0.00"
    valor_transferido_concedido "0.00"
    valor_contido "0.00"
    valor_contido_anulado "0.00"
    valor_descentralizado "0.00"
    valor_descentralizado_anulado "0.00"
    valor_empenhado "67342.83"
    valor_empenhado_anulado "0.00"
    valor_liquidado "50103.03"
    valor_liquidado_anulado "374.21"
    valor_liquidado_retido "50.26"
    valor_liquidado_retido_anulado "0.00"
    valor_pago "52846.69"
    valor_pago_anulado "374.21"

    after(:build) do |budget_balance|
      codigo_organ = budget_balance.cod_unid_gestora
      create(:integration_supports_organ, codigo_orgao: codigo_organ, poder: 'EXECUTIVO')
    end

    trait :invalid do
      ano_mes_competencia nil
    end
  end
end
