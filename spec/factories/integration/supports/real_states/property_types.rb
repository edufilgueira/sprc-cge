FactoryBot.define do
  factory :integration_supports_real_states_property_type, class: 'Integration::Supports::RealStates::PropertyType' do
    sequence(:title) { |n| "Terreno #{n}" }
  end
end
