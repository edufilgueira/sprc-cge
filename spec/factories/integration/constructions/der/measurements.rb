FactoryBot.define do
  factory :integration_constructions_der_measurement, class: 'Integration::Constructions::Der::Measurement' do
    integration_constructions_der
    id_medicao 5311
    id_obra 815
    id_status 2
    ano_mes "201611"
    ano_mes_date Date.new(2016, 11)
    numero_contrato_der "00432016"
    numero_contrato_sac "999807"
    numero_medicao 1
    rodovia "CE-284"
    status "CONCLUÍDO"
    status_medicao "Fechada"
    valor_medido 148832.28

    trait :invalid do
      integration_constructions_der nil
      id_obra nil
    end

  end
end
