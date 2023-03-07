FactoryBot.define do
  factory :integration_expenses_ned, class: 'Integration::Expenses::Ned' do
    exercicio Date.today.year
    unidade_gestora "101021"
    unidade_executora "101021"
    sequence(:numero) { |n| "#{n}" }
    numero_ned_ordinaria ""
    natureza "Ordinária"
    efeito "DESEMBOLSO"
    data_emissao { Date.today.to_s }
    valor "7058.06"
    valor_pago "7058.06"
    classificacao_orcamentaria_reduzido "1478"
    classificacao_orcamentaria_completo "10100002061220032238703339014001000003000"
    item_despesa "33901400001"
    cpf_ordenador_despesa "26022680387"
    credor "00822309"
    cpf_cnpj_credor "08042231733"
    razao_social_credor "PAULO RENATO FELIX FERREIRA"
    numero_npf_ordinario "00011129"
    projeto "1010210022016C"
    numero_parcela "861"
    isn_parcela "1454260"
    numero_contrato ""
    numero_convenio ""
    modalidade_sem_licitacao ""
    codigo_dispositivo_legal ""
    modalidade_licitacao ""
    tipo_proposta ""
    numero_proposta "11322"
    numero_proposta_origem ""
    numero_processo_protocolo_original "58161232017"
    especificacao_geral "VALOR REFERENTE AO PAGAMENTO DE DIÁRIAS DENTRO DO ESTADO, CONFORME PORTARIA 377/2017-DIFIN."
    data_atual "18/09/2017"

    trait :invalid do
      exercicio nil
    end

    trait :without_associations do
      classificacao_orcamentaria_completo '00000000000000000000000000000000099990000'
    end
  end
end
