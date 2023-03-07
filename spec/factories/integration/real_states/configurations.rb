FactoryBot.define do
  factory :integration_real_states_configuration, class: 'Integration::RealStates::Configuration' do
    wsdl "http://integracao.cge.ce.gov.br/cge-integracao/BensImoveisService?wsdl"
    headers_soap_action ""
    user "caiena"
    password "-"

    operation "consulta_imoveis"
    response_path "consulta_imoveis_response/lista_imoveis/imovel"

    detail_operation "detalha_imovel"
    detail_response_path "detalha_imovel_response/imovel"

    schedule

    trait :invalid do
      wsdl nil
    end
  end
end
