FactoryBot.define do
  factory :integration_contracts_adjustment, class: 'Integration::Contracts::Adjustment' do
    descricao_observacao "MyString"
    descricao_tipo_ajuste "MyString"
    data_ajuste "2017-06-14 20:05:24"
    data_alteracao "2017-06-14 20:05:24"
    data_exclusao "2017-06-14 20:05:24"
    data_inclusao "2017-06-14 20:05:24"
    data_inicio "2017-06-14 20:05:24"
    data_termino "2017-06-14 20:05:24"
    flg_acrescimo_reducao 1
    flg_controle_transmissao 1
    flg_receita_despesa 1
    flg_tipo_ajuste 1
    isn_contrato_ajuste 1
    isn_contrato_tipo_ajuste 1
    ins_edital 1
    isn_sic { contract.isn_sic }
    isn_situacao 1
    isn_usuario_alteracao 1
    isn_usuario_aprovacao 1
    isn_usuario_auditoria 1
    isn_usuario_exclusao 1
    valor_ajuste_destino "9.99"
    valor_ajuste_origem "9.99"
    valor_inicio_destino "9.99"
    valor_inicio_origem "9.99"
    valor_termino_origem "9.99"
    valor_termino_destino "9.99"
    descricao_url "MyString"
    num_apostilamento_siconv "MyString"
    association :contract, factory: :integration_contracts_contract

    trait :invalid do
      data_ajuste nil
    end
  end
end
