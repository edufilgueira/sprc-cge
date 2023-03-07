FactoryBot.define do
  factory :comment do
    description "Lorem Ipsum Dolor Sit Amet"
    association :commentable, factory: 'ticket'
    association :author, factory: 'user'

    trait :invalid do
      description nil
    end

    trait :internal do
      scope :internal
    end

    trait :external do
      scope :external
    end
  end
end
