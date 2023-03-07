FactoryBot.define do
  factory :integration_expenses_configuration, class: 'Integration::Expenses::Configuration' do
    npf_wsdl "http://integracao.cge.ce.gov.br/cge-integracao/NotaProgramacaoFinanceiraService?wsdl"
    npf_headers_soap_action ""
    npf_operation "consulta_nota_programacao_financeira"
    npf_response_path "consulta_nota_programacao_financeira_response/nota_programacao_financeira"
    npf_user "caiena"
    npf_password "-"
    ned_wsdl "http://integracao.cge.ce.gov.br/cge-integracao/NotaEmpenhoDespesaService?wsdl"
    ned_headers_soap_action ""
    ned_operation "consulta_nota_empenho_despesa"
    ned_response_path "consulta_nota_empenho_despesa_response/nota_empenho_despesa"
    ned_user "caiena"
    ned_password "-"
    nld_wsdl "http://integracao.cge.ce.gov.br/cge-integracao/NotaLiquidacaoDespesaService?wsdl"
    nld_headers_soap_action ""
    nld_operation "consulta_nota_liquidacao_despesa"
    nld_response_path "consulta_nota_liquidacao_despesa_response/nota_liquidacao_despesa"
    nld_user "caiena"
    nld_password "-"
    npd_wsdl "http://integracao.cge.ce.gov.br/cge-integracao/NotaPagamentoDespesaService?wsdl"
    npd_headers_soap_action ""
    npd_operation "consulta_nota_pagamento_despesa"
    npd_response_path "consulta_nota_pagamento_despesa_response/nota_pagamento_despesa"
    npd_user "caiena"
    npd_password "-"
    budget_balance_wsdl 'http//integracao.cge.ce.gov.br/cge-integracao/SaldoOrcamentarioService?wsdl'
    budget_balance_headers_soap_action ''
    budget_balance_user 'caiena'
    budget_balance_password '-'
    budget_balance_operation 'consulta_saldo_orcamentario'
    budget_balance_response_path 'consulta_saldo_orcamentario_response/saldo_orcamentario'

    last_importation "2017-09-18 14:27:42"
    log "MyText"
    status 1

    started_at Date.yesterday
    finished_at Date.yesterday

    schedule

    trait :invalid do
      npf_wsdl nil
    end
  end
end
