FactoryBot.define do
  factory :solvability_report do
    association :user, factory: [:user, :operator_cge]
    title "solvability report"
    sou
    status 1
    filename "MyString"
    processed 1

    trait :invalid do
      title nil
    end

    trait :sou do
      filters { { ticket_type: :sou } }
    end

    trait :sic do
      filters { { ticket_type: :sic } }
    end
  end
end
