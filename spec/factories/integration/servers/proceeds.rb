FactoryBot.define do
  factory :integration_servers_proceed, class: 'Integration::Servers::Proceed' do
    cod_orgao "MyString"
    dsc_matricula "MyString"
    num_ano { Date.current.last_month.year }
    num_mes { Date.current.last_month.month }
    cod_processamento "MyString"
    cod_provento { '123' }
    vlr_financeiro "9.99"
    vlr_vencimento "9.99"

    after(:build) do |proceed|
      if proceed.proceed_type.present?
        proceed.cod_provento = proceed.proceed_type.cod_provento
      end
    end

    trait :invalid do
      num_ano nil
    end

    trait :debit do
      association :proceed_type, factory: :integration_servers_proceed_type, dsc_tipo: "D"
    end

    trait :credit do
      association :proceed_type, factory: :integration_servers_proceed_type, dsc_tipo: "V"
    end
  end
end
