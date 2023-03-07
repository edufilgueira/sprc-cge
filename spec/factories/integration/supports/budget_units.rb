FactoryBot.define do
  factory :integration_supports_budget_unit, class: 'Integration::Supports::BudgetUnit' do

    sequence(:codigo_unidade_orcamentaria) { |n| "#{n}" }
    sequence(:codigo_unidade_gestora) { |n| "#{n}" }

    sequence(:titulo) { |n| "Unidade Orçamentária #{n}" }

    trait :invalid do
      codigo_unidade_orcamentaria nil
      codigo_unidade_gestora nil
      titulo nil
    end
  end
end
