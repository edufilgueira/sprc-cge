FactoryBot.define do
  factory :integration_supports_organ_configuration, class: 'Integration::Supports::Organ::Configuration' do
    wsdl "http://integracao.cge.ce.gov.br/cge-integracao/OrgaoService?wsdl"
    headers_soap_action ""
    user "caiena"
    password "-"
    operation "consulta_orgaos"
    response_path "consulta_orgaos_response/lista_orgao/orgao"
    status 1
    last_importation "2017-09-24 19:42:22"
    log "MyText"

    schedule

    trait :invalid do
      wsdl nil
    end
  end
end
