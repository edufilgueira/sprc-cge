FactoryBot.define do
  factory :integration_revenues_account_configuration, class: 'Integration::Revenues::AccountConfiguration' do
    account_number "5.2.1.1.1"
    title "PREVISÃO DE RECEITA"
    association :configuration, factory: :integration_revenues_configuration

    trait :invalid do
      account_number nil
    end
  end
end
