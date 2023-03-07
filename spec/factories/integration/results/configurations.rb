FactoryBot.define do
  factory :integration_results_configuration, class: 'Integration::Results::Configuration' do
    wsdl "http://integracao.cge.ce.gov.br/cge-integracao/IndicadoresService?wsdl"
    user "caiena"
    password "-"
    strategic_indicator_operation "consulta_indicadores_estrategicos"
    strategic_indicator_response_path "consulta_indicadores_estrategicos_response/lista_indicadores/indicador_estrategico"
    thematic_indicator_operation "consulta_indicadores_tematicos"
    thematic_indicator_response_path "consulta_indicadores_tematicos_response/lista_indicadores/indicador_tematico"
    status 1
    last_importation "2018-05-15 12:02:04"
    log "MyText"
    headers_soap_action ""

    schedule

    trait :invalid do
      wsdl nil
    end
  end
end
