FactoryBot.define do
  factory :department do
    sequence(:name) { |n| "Departamento de Contas #{n}" }
    organ
    sequence(:acronym) { |n| "CGE#{n}" }

    trait :invalid do
      organ nil
    end

    trait :with_subnet do
      subnet
      organ nil
    end
  end
end
