FactoryBot.define do
  factory :ppa_comment, parent: :ppa_interaction, class: 'PPA::Comment' do
    interactable { build(:ppa_strategy) }
    content "lorem lorem lorem lorem lorem lorem"

    trait :invalid do
      content nil
    end
  end
end
