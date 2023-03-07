FactoryBot.define do
  factory :integration_supports_creditor_configuration, class: 'Integration::Supports::Creditor::Configuration' do
    wsdl "http://integracao.cge.ce.gov.br/cge-integracao/CredorDespesaService?wsdl"
    headers_soap_action ""
    user "caiena"
    password "-"
    operation "consulta_credor"
    response_path "consulta_credor_response/credor"
    started_at Date.yesterday
    finished_at Date.today
    status 1
    last_importation "2017-09-26 10:30:50"
    log "MyText"

    schedule

    trait :invalid do
      wsdl nil
    end
  end
end
