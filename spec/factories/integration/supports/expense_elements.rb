FactoryBot.define do
  factory :integration_supports_expense_element, class: 'Integration::Supports::ExpenseElement' do
    sequence(:codigo_elemento_despesa) { |n| "#{n}" }
    eh_elementar true
    eh_licitacao true
    eh_transferencia true
    sequence(:titulo) { |n| "Categoria Economica #{n}" }

    trait :invalid do
      codigo_elemento_despesa nil
      titulo nil
    end
  end
end
