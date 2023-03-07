FactoryBot.define do
  factory :extension_user do
    token nil
    association :extension
    association :user, :operator_chief

    trait :invalid do
      extension nil
    end
  end
end
