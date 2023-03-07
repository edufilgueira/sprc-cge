FactoryBot.define do
  factory :integration_supports_management_unit, class: 'Integration::Supports::ManagementUnit' do
    sequence(:cgf) { |n| "#{n}" }
    sequence(:cnpj) { |n| "#{n}" }
    sequence(:codigo) { |n| "#{n}" }
    sequence(:codigo_credor) { |n| "#{n}" }
    poder "EXECUTIVO"
    sequence(:sigla) { |n| "#{n}" }
    sequence(:tipo_administracao) { |n| "#{n}" }
    sequence(:tipo_de_ug) { |n| "#{n}" }
    sequence(:titulo) { |n| "Unidade Gestora #{n}" }

    trait :invalid do
      cgf nil
      codigo nil
      codigo_credor nil
      poder nil
      sigla nil
      tipo_administracao nil
      tipo_de_ug nil
      titulo nil
    end
  end
end
