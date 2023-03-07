FactoryBot.define do
  factory :ticket_department_email do
    ticket_department
    sequence(:email) { |n| "email-#{n}@example.com" }
    token nil

    trait :invalid do
      ticket_department nil
      email nil
    end

    trait :with_positioning do
      association :answer, factory: [:answer, :awaiting_positioning]
      active false
    end
  end
end
