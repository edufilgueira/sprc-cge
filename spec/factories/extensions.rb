FactoryBot.define do
  factory :extension do
    description 'MyText'
    email ''
    association :ticket, :with_parent

    trait :invalid do
      description nil
    end

    trait :department do
      ticket_department
    end

    trait :in_progress do
      status :in_progress
    end

    trait :second do
      solicitation 2
    end
  end
end
