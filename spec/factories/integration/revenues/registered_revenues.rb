FactoryBot.define do
  factory :integration_revenues_registered_revenue, class: 'Integration::Revenues::RegisteredRevenue' do
    unidade "190001"
    sequence(:poder) { |n| "EXECUTIVO #{n}" }
    sequence(:administracao) { |n| "DIRETA #{n}" }
    conta_contabil "4.1.1.2.1.03.01"
    sequence(:titulo) { |n| "IPVA #{n}" }
    natureza_da_conta "DÉBITO"
    natureza_credito "DEBITO"
    valor_credito 7065.70
    natureza_debito "CRÉDITO"
    valor_debito 230481055.37
    valor_inicial 0
    natureza_inicial nil
    fechamento_contabil "4"
    data_atual { Date.today }
    association :account_configuration, factory: :integration_revenues_account_configuration
    month { Date.today.last_month.month }
    year { Date.today.last_month.year }

    trait :invalid do
      unidade nil
      poder nil
    end

    trait :with_organ do
      association :organ, factory: :integration_supports_organ
    end

    trait :with_account do
      after(:create) do |revenue|
        create(:integration_revenues_account, revenue: revenue)
      end
    end
  end
end
