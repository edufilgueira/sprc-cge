FactoryBot.define do
  factory :integration_constructions_configuration, class: 'Integration::Constructions::Configuration' do
    headers_soap_action ''
    user 'caiena'
    password '-'

    der_wsdl 'http://integracao.cge.ce.gov.br/cge-integracao/ObrasDerService?wsdl'
    dae_wsdl 'http://integracao.cge.ce.gov.br/cge-integracao/ObrasDaeService?wsdl'

    der_operation "consulta_obras"
    der_response_path "consulta_obras_response/lista_obras/obra"

    der_contract_operation "consulta_contratos_obras"
    der_contract_response_path "consulta_contratos_obras_response/lista_contratos_obras/contrato_obra"

    der_measurement_operation "consulta_medicoes_obra"
    der_measurement_response_path "consulta_medicoes_obra_response/lista_medicoes_obra/medicao_obra"

    dae_operation "consulta_obras"
    dae_response_path "consulta_obras_response/lista_obras/obra"

    dae_measurement_operation "consulta_obra_medicao"
    dae_measurement_response_path "consulta_obra_medicao_response/lista_obras_medicoes/obra_medicao"

    dae_photo_operation "consulta_foto_medicao"
    dae_photo_response_path "consulta_foto_medicao_response/lista_foto_medicao/foto_medicao"

    last_importation { DateTime.current }
    log "MyText"
    status 1

    schedule

    trait :invalid do
      der_wsdl nil
    end

  end
end
