FactoryBot.define do
  factory :integration_real_states_real_state, class: 'Integration::RealStates::RealState' do
    manager { create(:integration_supports_organ) }
    property_type { create(:integration_supports_real_states_property_type) }
    occupation_type { create(:integration_supports_real_states_occupation_type) }
    service_id "6"
    descricao_imovel "TERRENO-ISSEC-FORTALEZA"
    estado "CEARÁ"
    municipio "Fortaleza"
    area_projecao_construcao "54.4"
    area_medida_in_loco "486.0"
    area_registrada "0.0"
    frente "12"
    fundo "12"
    lateral_direita "40.5"
    lateral_esquerda "40.5"
    taxa_ocupacao "11.19"
    fracao_ideal "1.0"
    numero_imovel nil
    utm_zona "24"
    bairro nil
    cep "60.823-110"
    endereco "RUA MELO CÉSAR, ESQ. COM RUA ESCRIVÃO AZEVEDO"
    complemento "-"
    lote "10"
    quadra "15"

    trait :invalid do
      manager nil
      property_type nil
      occupation_type nil
      estado ''
      municipio ''
      service_id ''
    end
  end
end
