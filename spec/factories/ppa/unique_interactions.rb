FactoryBot.define do
  factory :ppa_unique_interaction, parent: :ppa_interaction, class: 'PPA::UniqueInteraction' do
    interactable { build(:ppa_strategy) }

    trait :invalid do
      user nil
    end
  end
end
