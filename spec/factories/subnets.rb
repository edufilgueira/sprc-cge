FactoryBot.define do
  factory :subnet do
    sequence(:acronym) {|n| "SUB-#{n}"}
    sequence(:name) {|n| "Sub-rede-#{n}"}
    association :organ, factory: [:executive_organ, :with_subnet]

    trait :invalid do
      name nil
    end
  end
end
