FactoryBot.define do
  factory :integration_constructions_dae, class: 'Integration::Constructions::Dae' do
    id_obra 7244
    codigo_obra "0262015FUNECE01"
    contratada "PODIUM"
    data_fim_previsto "Thu, 28 Sep 2017"
    data_inicio "Fri, 24 Apr 2015"
    data_ordem_servico "Fri, 24 Apr 2015"
    descricao "OBRA 1ª ETAPA DA URBANIZAÇÃO DO COMPLEXO POLIESPORTIVO CAMPUS ITAPERI E URBANIZAÇÃO DO HOSPITAL VETERINÁRIO DA UECE EM FORTALEZA-CE"
    dias_aditivado 709
    latitude " -3.795659"
    longitude "-38.555633"
    municipio "FORTALEZA"
    numero_licitacao "20140001"
    numero_ordem_servico "041/2015"
    numero_sacc "940834"
    percentual_executado "89.86"
    prazo_inicial 180
    secretaria "FUNECE"
    status "Em Execução"
    tipo_contrato "Obra"
    valor "2275667.44"
    organ { create(:integration_supports_organ, orgao_sfp: false) }

    trait :invalid do
      id_obra nil
      organ nil
    end
  end
end
