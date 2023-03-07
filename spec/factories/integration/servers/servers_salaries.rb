FactoryBot.define do
  factory :integration_servers_server_salary, class: 'Integration::Servers::ServerSalary' do
    association :registration, factory: :integration_servers_registration
    association :role, factory: :integration_supports_server_role
    association :organ, factory: :integration_supports_organ

    sequence(:server_name) {|n| "Servidor-#{n}" }

    # É importante ser o começo do mês pois o controler é por mes/ano e o
    # importardor grava todos no primeiro dia do mês
    date { Date.today.beginning_of_month }

    income_total 2
    income_final 1
    income_dailies 1

    discount_total 1
    discount_under_roof 1
    discount_others 0

    trait :invalid do
      registration nil
    end
  end
end
