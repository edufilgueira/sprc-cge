FactoryBot.define do
  factory :integration_expenses_ned_planning_item, class: 'Integration::Expenses::NedPlanningItem' do
    isn_item_parcela "1617908"
    valor "38.55"
    association :ned, factory: :integration_expenses_ned

    trait :invalid do
      ned nil
    end
  end
end
