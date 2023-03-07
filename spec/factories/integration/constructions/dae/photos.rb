FactoryBot.define do
  factory :integration_constructions_dae_photo, class: 'Integration::Constructions::Dae::Photo' do
    integration_constructions_dae
    id_medicao 38312
    codigo_obra "02052016SEDUC01"
    descricao_conta_associada "FUNDAÇÕES E ESTRUTURAS"
    legenda "Execução de laje da coberta"
    url_foto "http://sigdae.dae.ce.gov.br/ARQUIVOS/FOTO_MEDICAO_CONTRATADA/38312/61743.jpeg"

    trait :invalid do
      integration_constructions_dae nil
      id_medicao nil
      codigo_obra nil
    end
  end
end
