FactoryBot.define do
  factory :topic do
    sequence(:name) {|n| "Name #{n}"}
    organ nil

    trait :invalid do
      name nil
    end

    trait :other_organs do
      other_organs true
    end

    trait :no_characteristic do
      name "MANIFESTAÇÃO SEM CARACTERÍSTICA"
    end
  end
end
