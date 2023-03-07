FactoryBot.define do
  factory :ticket_like do
    ticket
    user

    trait :invalid do
      ticket nil
      user nil
    end
  end
end
