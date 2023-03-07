FactoryBot.define do
  factory :integration_servers_server, class: 'Integration::Servers::Server' do
    sequence(:dsc_cpf) { |n| "999.999.999-#{n}" }
    sequence(:dsc_funcionario) { |n| "Funcionário #{n}" }
    dth_nascimento "2017-05-30"

    trait :invalid do
      dsc_cpf ""
    end

    trait :with_registration do
      after(:create) do |server|
        create(:integration_servers_registration, server: server, cod_situacao_funcional: '0')
        create(:integration_servers_registration, server: server, cod_situacao_funcional: '0')
      end
    end

    trait :with_salaries do
      after(:create) do |server|
        registration = create(:integration_servers_registration, server: server, cod_situacao_funcional: '0')
        another_registration = create(:integration_servers_registration, server: server, cod_situacao_funcional: '0')

        create(:integration_servers_server_salary, registration: registration, server_name: server.dsc_funcionario)
        create(:integration_servers_server_salary, registration: another_registration, server_name: server.dsc_funcionario)
      end
    end

    trait :with_proceed do
      after(:create) do |server|
        registration = create(:integration_servers_registration, server: server, cod_situacao_funcional: '0')
        proceed_type = create(:integration_servers_proceed_type, dsc_tipo: 'V')
        create(:integration_servers_proceed, num_ano: "2017", num_mes: "9", vlr_financeiro: 2000, proceed_type: proceed_type, registration: registration)
      end
    end
  end
end
