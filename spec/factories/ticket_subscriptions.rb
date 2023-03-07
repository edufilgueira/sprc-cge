FactoryBot.define do
  factory :ticket_subscription do
    ticket
    user
    sequence(:email) {|n| "email#{n}@example.com"}

    confirmed_email false
    token nil

    trait :invalid do
      ticket nil
    end

    trait :unconfirmed do
      token 'token'
      confirmed_email false
    end

    trait :confirmed do
      token 'token'
      confirmed_email true
    end
  end
end
