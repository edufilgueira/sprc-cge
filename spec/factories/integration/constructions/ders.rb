FactoryBot.define do
  factory :integration_constructions_der, class: 'Integration::Constructions::Der' do
    base "100"
    cerca "100"
    conclusao "Mon, 05 Oct 2009"
    construtora "SAMARIA"
    cor_status "#1127b8"
    data_fim_contrato "Tue, 01 Dec 2009"
    data_fim_previsto "Tue, 01 Dec 2009"
    distrito "04 - LIMOEIRO DO NORTE"
    drenagem "100"
    extensao "10.3"
    id_obra 308
    numero_contrato_der "01172008"
    numero_contrato_ext ""
    numero_contrato_sic "189776"
    obra_darte "100"
    percentual_executado 100
    programa "Ceará III (004)"
    qtd_empregos 0
    qtd_geo_referencias 1
    revestimento "100"
    rodovia "CE-371"
    servicos "Restauração: Entr° BR-116 - Palhano"
    sinalizacao "100"
    status "CONCLUÍDO"
    supervisora "RNR"
    terraplanagem "100"
    trecho "ENTR. BR-116 - PALHANO"
    ult_atual "Wed, 26 Aug 2009"
    valor_aprovado "2450132.35"

    trait :contract_der do
      data_inicio_obra "Mon 01 Jul 2013"
      data_ordem_servico "Mon 01 Jul 2013"
      dias_adicionado 0
      dias_suspenso 0
      municipio "LIMOEIRO DO NORTE"
      numero_ordem_servico "099/2013"
      prazo_inicial 540
      total_aditivo 0.00
      total_reajuste 0.00
      valor_atual 18262239.38
      valor_original 18262239.38
      valor_pi 18262239.38
    end

    trait :invalid do
      id_obra nil
    end
  end
end
