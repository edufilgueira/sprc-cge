FactoryBot.define do
  factory :ticket_report do
    association :user, factory: [:user, :operator_cge]
    title "MyString"
    filters { { ticket_type: :sou } }
    status 1
    filename "MyString"
    processed 1

    trait :invalid do
      title nil
    end

    trait :sic do
      filters { { ticket_type: :sic } }
    end

    trait :sectoral do
      association :user, factory: [:user, :operator_sectoral]
      filters { { ticket_type: :sou, organ: user.organ_id } }

    end
  end
end
