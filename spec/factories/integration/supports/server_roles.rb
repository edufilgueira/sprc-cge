FactoryBot.define do
  factory :integration_supports_server_role, class: 'Integration::Supports::ServerRole' do

    # o sequence é importante para testar as colunas buscáveis em model/search
    # pois já diferencia os registros.

    sequence(:name) {|n| "Cargo-#{n}"}

    trait :invalid do
      name nil
    end
  end
end
