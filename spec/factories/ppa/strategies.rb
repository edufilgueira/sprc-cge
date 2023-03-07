FactoryBot.define do
  factory :ppa_strategy, class: 'PPA::Strategy' do
    association :objective, factory: :ppa_objective

    sequence(:code) { |n| "ST-#{n}" }
    sequence(:isn) { |n| n }
    name "Strategy, from greek stratiyeia"

    trait :invalid do
      code nil
    end
  end
end
