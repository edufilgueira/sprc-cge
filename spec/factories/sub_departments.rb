FactoryBot.define do
  factory :sub_department do
    name "Contas"
    department
    acronym "CGE"

    trait :invalid do
      acronym nil
    end
  end
end
