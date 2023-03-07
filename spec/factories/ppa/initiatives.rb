FactoryBot.define do
  factory :ppa_initiative, class: 'PPA::Initiative' do
    sequence(:code) { |n| "IN-#{n}" }
    name "A Initiative"

    trait :invalid do
      name nil
    end
  end
end
