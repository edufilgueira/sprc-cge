FactoryBot.define do
  factory :classification do
    association :ticket, factory: [:ticket, :confirmed]
    topic
    budget_program
    department
    sub_department
    service_type
    other_organs false

    trait :with_subtopic do
      subtopic
    end

    trait :invalid do
      topic           nil
      budget_program  nil
    end

    trait :other_organs do
      other_organs true

      association :topic, factory: [:topic, :other_organs]
      association :subtopic, factory: [:subtopic, :other_organs]
      association :budget_program, factory: [:budget_program, :other_organs]
      association :service_type, factory: [:service_type, :other_organs]
      department  nil
      sub_department nil
    end

    trait :other_organs_invalidated do
      other_organs
      association :ticket, factory: [:ticket, :confirmed, :invalidated]
    end

    trait :sic do
      association :ticket, factory: [:ticket, :confirmed, :sic]
    end
  end
end
