FactoryBot.define do
  factory :integration_supports_expense_nature_group, class: 'Integration::Supports::ExpenseNatureGroup' do
    sequence(:codigo_grupo_natureza) { |n| "#{n}" }
    sequence(:titulo) { |n| "Grupo de Natureza da Despesa #{n}" }

    trait :invalid do
      codigo_grupo_natureza nil
      titulo nil
    end
  end
end
