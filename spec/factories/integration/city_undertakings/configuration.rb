FactoryBot.define do
  factory :integration_city_undertakings_configuration, class: 'Integration::CityUndertakings::Configuration' do
    wsdl "http://integracao.cge.ce.gov.br/cge-integracao/ContratosConveniosService?wsdl"
    user "caiena"
    password "-"
    headers_soap_action ""

    undertaking_operation "consulta_empreendimentos"
    undertaking_response_path "consulta_empreendimentos_response/lista_empreendimentos/empreendimento"

    city_undertaking_operation "consulta_municipios_empreendimentos"
    city_undertaking_response_path "consulta_municipios_empreendimentos_response/lista_municipios_empreendimentos/municipio_empreendimento"

    city_organ_operation "consulta_municipios_secretarias"
    city_organ_response_path "consulta_municipios_secretarias_response/lista_municipios_secretarias/municipio_secretaria"

    log "-"
    status :status_in_progress
    last_importation { DateTime.current }

    schedule

    trait :invalid do
      wsdl nil
    end

  end
end
