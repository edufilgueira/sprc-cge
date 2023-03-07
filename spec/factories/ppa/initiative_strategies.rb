FactoryBot.define do
  factory :ppa_initiative_strategy, class: 'PPA::InitiativeStrategy' do
    association :initiative, factory: :ppa_initiative
    association :strategy, factory: :ppa_strategy

    trait :invalid do
      initiative nil
    end
  end
end
