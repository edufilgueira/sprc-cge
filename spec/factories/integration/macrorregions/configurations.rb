FactoryBot.define do
  factory :integration_macroregions_configuration, class: 'Integration::Macroregions::Configuration' do
    wsdl 'http://integracao.cge.ce.gov.br/cge-integracao/InvestimentoMacroregiaoService?wsdl'
    headers_soap_action ''
    user 'caiena'
    password '-'
    power 1
    year 2018
    operation 'consultar_investimentos_macroregiao'
    response_path 'consultar_investimentos_macroregiao_response/lista_investimentos_macroregiao/investimentos_macroregiao'
    status 1
    last_importation '2018-06-09 17:32:20'
    log 'MyText'

    schedule

    trait :invalid do
      wsdl nil
    end
  end
end
