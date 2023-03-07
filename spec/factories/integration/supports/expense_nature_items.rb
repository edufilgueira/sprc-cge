FactoryBot.define do
  factory :integration_supports_expense_nature_item, class: 'Integration::Supports::ExpenseNatureItem' do
    sequence(:codigo_item_natureza) { |n| "#{n}" }
    sequence(:titulo) { |n| "Item de Natureza da Despesa #{n}" }

    trait :invalid do
      codigo_item_natureza nil
      titulo nil
    end
  end
end
