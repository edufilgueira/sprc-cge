FactoryBot.define do
  factory :integration_eparcerias_configuration, class: 'Integration::Eparcerias::Configuration' do
    headers_soap_action ''
    wsdl 'http://integracao.cge.ce.gov.br/cge-integracao/EparceriasService?wsdl'
    user 'caiena'
    password '-'

    transfer_bank_order_operation "consulta_ordens_bancarias"
    transfer_bank_order_response_path "consulta_ordens_bancarias_response/lista_ordem_bancaria/ordem_bancaria"

    work_plan_attachment_operation "consulta_anexos_plano_trabalho"
    work_plan_attachment_response_path "consulta_anexos_plano_trabalho_response/lista_anexo_plano_trabalho/anexo_arquivo"

    accountability_operation "consulta_situacao_prestacao_contas"
    accountability_response_path "consulta_situacao_prestacao_contas_response/situacao_prestacao_contas"

    import_type :import_all

    status :status_in_progress
    last_importation { DateTime.current }

    schedule

    trait :invalid do
      wsdl nil
    end
  end
end
