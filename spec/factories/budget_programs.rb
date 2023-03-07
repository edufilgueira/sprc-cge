FactoryBot.define do
  factory :budget_program do
    sequence(:name) { |n| "Departamento de Contas #{n}" }
    code "ALPHA123"

    trait :invalid do
      name nil
    end

    trait :other_organs do
      other_organs true
    end

    trait :with_organ do
      organ
      subnet nil
    end

    trait :with_subnet do
      subnet
      organ nil
    end

    trait :no_characteristic do
      name 'NÃO SE APLICA'
    end
  end
end
