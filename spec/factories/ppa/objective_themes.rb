FactoryBot.define do
  factory :ppa_objective_theme, class: 'PPA::ObjectiveTheme' do
    association :region, factory: :ppa_region
    association :objective, factory: :ppa_objective
    association :theme, factory: :ppa_theme

    trait :invalid do
      objective nil
    end
  end
end
