FactoryBot.define do
  factory :integration_expenses_npf, class: 'Integration::Expenses::Npf' do
    exercicio 2017
    sequence(:unidade_gestora) { |n| "#{n}" }
    unidade_executora ""
    sequence(:numero) { |n| "#{n}" }
    numero_npf_ord ""
    natureza ""
    tipo_proc_adm_desp ""
    efeito ""
    data_emissao ""
    grupo_fin ""
    fonte_rec ""
    valor ""
    credor ""
    codigo_projeto ""
    numero_parcela ""
    isn_parcela ""
    numeroconvenio ""
    data_atual ""

    trait :invalid do
      exercicio nil
    end
  end
end
