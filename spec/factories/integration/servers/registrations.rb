FactoryBot.define do
  factory :integration_servers_registration, class: 'Integration::Servers::Registration' do
    sequence(:dsc_matricula) { |n| "#{n}" }
    sequence(:cod_orgao)
    sequence(:dsc_funcionario) { |n| "Funcionário #{n}" }
    sequence(:dsc_cargo)  { |n| "Cargo #{n}" }
    dth_nascimento "2017-05-30"
    dsc_cpf "MyString"
    num_folha "MyString"
    cod_situacao_funcional "0"
    cod_afastamento "MyString"
    dth_afastamento "2017-05-30"
    vlr_carga_horaria 1
    vdth_admissao Date.today
    association :organ, factory: :integration_supports_organ
    association :server, factory: :integration_servers_server

    trait :invalid do
      dsc_matricula ""
    end

    trait :with_proceed do
      after(:create) do |registration|
        create(:integration_servers_proceed, registration: registration)
        create(:integration_servers_proceed, :debit, registration: registration)
      end
    end

    trait :with_server do
      association :server, factory: :integration_servers_server
    end
  end
end
