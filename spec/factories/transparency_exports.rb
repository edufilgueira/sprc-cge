FactoryBot.define do
  factory :transparency_export, class: 'Transparency::Export' do
    name "Minha exportação do salário dos servidores"
    email "cidadao@example.com"
    query 'SELECT...'
    resource_name 'ModelName'
    filename ''
    expiration nil
    status nil
    worksheet_format 0

    trait :server_salary do
      query 'SELECT * FROM integration_servers_server_salaries'
      resource_name 'Integration::Servers::ServerSalary'
    end

    trait :revenues_account do
      query 'SELECT * FROM integration_revenues_accounts'
      resource_name 'Integration::Revenues::Account'
    end

    trait :revenues_transfer do
      query 'SELECT * FROM integration_revenues_accounts'
      resource_name 'Integration::Revenues::Transfer'
    end

    trait :expenses_budget_balance do
      query 'SELECT * FROM integration_expenses_budget_balances'
      resource_name 'Integration::Expenses::BudgetBalance'
    end

    trait :contract do
      query 'SELECT * FROM integration_contracts_contracts'
      resource_name 'Integration::Contracts::Contract'
    end

    trait :convenant do
      query 'SELECT * FROM integration_contracts_convenants'
      resource_name 'Integration::Contracts::Convenant'
    end

    trait :purchase do
      query 'SELECT * FROM integration_purchases_purchases'
      resource_name 'Integration::Purchases::Purchase'
    end

    trait :user do
      query 'SELECT * FROM users'
      resource_name 'User'
    end

    trait :invalid do
      email nil
    end
  end
end
