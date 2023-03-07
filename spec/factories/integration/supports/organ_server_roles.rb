FactoryBot.define do
  factory :integration_supports_organ_server_role, class: 'Integration::Supports::OrganServerRole' do
    association :organ, factory: :integration_supports_organ
    association :role, factory: :integration_supports_server_role

    trait :invalid do
      organ nil
      role nil
    end
  end
end
