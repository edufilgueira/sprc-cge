FactoryBot.define do
  factory :integration_revenues_configuration, class: 'Integration::Revenues::Configuration' do
    wsdl 'http://integracao.cge.ce.gov.br/cge-ws-ear-cge-ws-ejb/SaldoContaReceitaService?wsdl'
    headers_soap_action ''
    user 'caiena'
    password '-'
    operation 'consulta_saldo_contas_contabeis'
    response_path 'consulta_saldo_contas_contabeis_response/conta'
    month '05/2017'

    schedule

    trait :invalid do
      wsdl nil
    end
  end
end
