FactoryBot.define do
  factory :occurrence do
    description "Lorem Ipsum"
    attendance
    association :created_by, factory: :user

    trait :invalid do
      description nil
    end
  end
end
