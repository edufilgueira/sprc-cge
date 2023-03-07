FactoryBot.define do
  factory :evaluation_export do
    association :user, factory: [:user, :operator_cge]
    title "Evaluation export"
    status :preparing
    sou
    filename "MyString"

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
