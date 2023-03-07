FactoryBot.define do
  factory :integration_supports_real_states_occupation_type, class: 'Integration::Supports::RealStates::OccupationType' do
    sequence(:title) { |n| "Residência #{n}" }
  end
end
