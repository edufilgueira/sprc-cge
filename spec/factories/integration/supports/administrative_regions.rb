FactoryBot.define do
  factory :integration_supports_administrative_region, class: 'Integration::Supports::AdministrativeRegion' do
    sequence(:codigo_regiao) { |n| "#{n}" }
    sequence(:titulo) { |n| "Região administrativa #{n}" }

    trait :invalid do
      codigo_regiao nil
      titulo nil
    end
  end
end
