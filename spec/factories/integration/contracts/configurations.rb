FactoryBot.define do
  factory :integration_contracts_configuration, class: 'Integration::Contracts::Configuration' do
    headers_soap_action ''
    wsdl 'http://integracao.cge.ce.gov.br/cge-integracao/ContratosConveniosService?wsdl'
    user 'caiena'
    password '-'
    contract_operation "consulta_contratos_convenios"
    contract_response_path "consulta_contratos_convenios_response/lista_contratos_convenios/contrato_convenio"
    contract_parameters "dataAssinaturaInicial=BEGIN_MONTH&dataAssinaturaFinal=END_MONTH"
    additive_operation "consulta_aditivo"
    additive_response_path "consulta_aditivo_response/lista_aditivo/aditivo"
    additive_parameters "dataAditivoInicial=BEGIN_MONTH&dataAditivoFinal=END_MONTH"
    adjustment_operation "consulta_apostilamento"
    adjustment_response_path "consulta_apostilamento_response/lista_apostilamento/apostilamento"
    adjustment_parameters "dataAditivoInicial=BEGIN_MONTH&dataAditivoFinal=END_MONTH"
    financial_operation "consulta_financeiro"
    financial_response_path "consulta_financeiro_response/lista_financeiro/financeiro"
    financial_parameters "dataDocumentoInicial=BEGIN_MONTH&dataDocumentoFinal=END_MONTH"
    infringement_operation "consulta_inadimplencia"
    infringement_response_path "consulta_inadimplencia_response/lista_inadimplencia/inadimplencia"
    infringement_parameters ""
    status :status_in_progress
    last_importation { DateTime.current }

    schedule

    trait :invalid do
      wsdl nil
    end
  end
end
