FactoryBot.define do
  factory :mobile_tag do
    sequence(:name) {|n| "TAG-#{n}"}

    trait :invalid do
      name nil
    end
  end
end
