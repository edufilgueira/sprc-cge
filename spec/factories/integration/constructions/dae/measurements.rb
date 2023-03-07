FactoryBot.define do
  factory :integration_constructions_dae_measurement, class: 'Integration::Constructions::Dae::Measurement' do
    integration_constructions_dae
    ano_mes "MyString"
    ano_mes_date "2018-06-25"
    codigo_obra "MyString"
    data_fim "2018-06-25 16:45:07"
    data_inicio "2018-06-25 16:45:07"
    id_medicao 1
    numero_medicao "MyString"
    valor_medido "9.99"

    trait :invalid do
      integration_constructions_dae nil
      codigo_obra nil
      id_medicao nil
    end
  end
end
