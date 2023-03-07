FactoryBot.define do
  factory :ticket_department do
    association :ticket, :with_parent
    department
    description "MyText"
    note "Note"
    considerations "Note + Justification"
    answer :not_answered
    deadline_ends_at { Date.today + Ticket.response_deadline(:sou) }
    deadline { Ticket.response_deadline(:sou) }

    trait :invalid do
      ticket nil
    end

    trait :answered do
      answer :answered
    end

    trait :without_deadline do
      deadline_ends_at nil
      deadline nil
    end

    trait :with_ticket do
      association :ticket, factory: [:ticket]
    end
  end
end

