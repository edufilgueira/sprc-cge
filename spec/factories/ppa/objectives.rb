FactoryBot.define do
  factory :ppa_objective, class: 'PPA::Objective' do
    association :region, factory: :ppa_region

    sequence(:code) { |n| "OB-#{n}" }
    sequence(:isn) { |n| n }
    name "An Objective"

    trait :invalid do
      code nil
    end
  end
end
