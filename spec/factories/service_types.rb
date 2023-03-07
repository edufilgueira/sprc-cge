FactoryBot.define do
  factory :service_type do
    name "Nome do tipo de serviço"
    code 1
    association :organ, factory: [:executive_organ]

    trait :invalid do
      name nil
    end

    trait :other_organs do
      other_organs true
      organ nil
    end

    trait :no_characteristic do
      name 'NÃO SE APLICA'
      organ nil
    end

  end
end
