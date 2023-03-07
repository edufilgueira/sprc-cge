FactoryBot.define do
  factory :holiday do
    title "MyString"
    day 1
    month 1

    trait :invalid do
      day nil
    end
  end
end
