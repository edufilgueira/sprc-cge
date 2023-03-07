FactoryBot.define do
  factory :event do
    title "MyString"
    starts_at Time.current
    description "MyText"

    trait :invalid do
      title ''
      starts_at nil
      description ''
    end
  end
end
