FactoryBot.define do
  factory :theme do
    code '1.01'
    name 'Gestão fiscal'

    trait :invalid do
      name nil
    end
  end
end
