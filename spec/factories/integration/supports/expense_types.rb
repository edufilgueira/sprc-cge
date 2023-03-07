FactoryBot.define do
  factory :integration_supports_expense_type, class: 'Integration::Supports::ExpenseType' do
    sequence(:codigo) { |n| "#{n}" }

    trait :invalid do
      codigo nil
    end
  end
end
