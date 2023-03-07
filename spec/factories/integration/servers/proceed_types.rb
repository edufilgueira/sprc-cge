FactoryBot.define do
  factory :integration_servers_proceed_type, class: 'Integration::Servers::ProceedType' do
    sequence(:cod_provento) {|n| n}
    sequence(:dsc_provento) {|n| "Provento tipo #{n}"}
    dsc_tipo "V"
    origin 0

    trait :invalid do
      dsc_provento ""
    end

    trait :debit do
      dsc_tipo "D"
    end
  end
end
