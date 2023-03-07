FactoryBot.define do
  factory :integration_supports_domain_configuration, class: 'Integration::Supports::Domain::Configuration' do
    wsdl "http://integracao.cge.ce.gov.br/cge-integracao/TabelaExercicioService?wsdl"
    headers_soap_action ""
    user "caiena"
    password "-"
    operation "consulta_tabela_exercicio"
    response_path "consulta_tabela_exercicio_response/tabela_exercicio"
    year Date.today.year
    status 1
    last_importation "2017-09-26 10:30:50"
    log "MyText"

    schedule

    trait :invalid do
      wsdl nil
    end
  end
end
