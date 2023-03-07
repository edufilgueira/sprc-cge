FactoryBot.define do
  factory :subtopic do
    sequence(:name) { |n| "Subtopic-#{n}" }
    topic

    trait :invalid do
      name nil
    end

    trait :other_organs do
      other_organs true
    end
  end
end
