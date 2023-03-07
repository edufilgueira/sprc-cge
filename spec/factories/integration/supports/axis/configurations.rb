FactoryBot.define do
  factory :integration_supports_axis_configuration, class: 'Integration::Supports::Axis::Configuration' do
    wsdl "http://integracao.cge.ce.gov.br/cge-integracao/IndicadoresService?wsdl"
    headers_soap_action ""
    user "caiena"
    password "-"
    operation "consulta_eixos"
    response_path "consulta_eixos_response/lista_eixos/eixo"
    status 1
    last_importation "2017-09-24 19:42:22"
    log "MyText"

    schedule

    trait :invalid do
      wsdl nil
    end
  end
end
