FactoryBot.define do
  factory :ppa_product, class: 'PPA::Product' do

    association :initiative, factory: :ppa_initiative

    sequence(:code) { |n| "PR-#{n}" }
    name "A Product"

    trait :invalid do
      name nil
    end
  end
end
