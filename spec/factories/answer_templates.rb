FactoryBot.define do
  factory :answer_template do
    name "Template name"
    content "Template content"
    user

    trait :invalid do
      user nil
      name ''
      content ''
    end
  end
end
