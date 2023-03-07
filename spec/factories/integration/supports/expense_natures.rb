FactoryBot.define do
  factory :integration_supports_expense_nature, class: 'Integration::Supports::ExpenseNature' do
    sequence(:codigo_natureza_despesa) { |n| "#{n}" }
    sequence(:titulo) { |n| "Natureza da Despesa #{n}" }

    trait :invalid do
      codigo_natureza_despesa nil
      titulo nil
    end
  end
end
