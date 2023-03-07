FactoryBot.define do
  factory :integration_purchases_configuration, class: 'Integration::Purchases::Configuration' do
    wsdl 'http://integracao.cge.ce.gov.br/cge-integracao/ComprasService?wsdl'
    headers_soap_action ''
    user 'caiena'
    password '-'
    operation 'consulta_compras'
    response_path 'consulta_compras_response/lista_compras/compras'
    month '05/2017'

    schedule

    trait :invalid do
      wsdl nil
    end
  end
end
