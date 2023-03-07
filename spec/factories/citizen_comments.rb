FactoryBot.define do
  factory :citizen_comment do
    description 'Citizen comment'
    ticket
    user

    trait :invalid do
      ticket nil
      user nil
      description nil
    end

  end
end
