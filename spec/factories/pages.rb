FactoryBot.define do
  factory :page do
    title "MyString"
    content "MyText"
    sequence(:menu_title) { |n| "menu title-#{n}" }
    status :active

    trait :invalid do
      content nil
    end

    trait :with_parent do
      association :parent, factory: [:page]
    end
  end
end
