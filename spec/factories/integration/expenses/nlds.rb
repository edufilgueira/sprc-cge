FactoryBot.define do
  factory :integration_expenses_nld, class: 'Integration::Expenses::Nld' do
    exercicio Date.today.year
    unidade_gestora "101021"
    unidade_executora "101021"
    sequence(:numero) { |n| "#{n}" }
    numero_nld_ordinaria ""
    natureza "ORDINARIA"
    tipo_de_documento_da_despesa ""
    numero_do_documento_da_despesa ""
    data_do_documento_da_despesa ""
    efeito ""
    processo_administrativo_despesa ""
    data_emissao ""
    valor "9.99"
    valor_retido "9.99"
    cpf_ordenador_despesa ""
    credor ""
    numero_npf_ordinaria ""
    numero_nota_empenho_despesa "769"
    tipo_despesa_extra_orcamentaria ""
    especificacao_restituicao ""
    exercicio_restos_a_pagar ""
    data_atual ""

    trait :invalid do
      exercicio nil
    end
  end
end
