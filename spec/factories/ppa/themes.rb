FactoryBot.define do
  factory :ppa_theme, class: 'PPA::Theme' do
    association :axis, factory: :ppa_axis
    sequence(:code) { |n| "TM-#{n}" }
    sequence(:isn) { |n| n }

    name "A Theme"
    description "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

    trait :invalid do
      name nil
    end
  end
end
