FactoryBot.define do
  factory :gross_export do
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

    trait :all_columns do
      load_creator_info true
      load_answers true
      load_description true
    end
  end
end
