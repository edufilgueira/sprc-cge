FactoryBot.define do
  factory :integration_supports_finance_group, class: 'Integration::Supports::FinanceGroup' do
    sequence(:codigo_grupo_financeiro) { |n| "#{n}" }
    sequence(:titulo) { |n| "Grupo Financeiro #{n}" }

    trait :invalid do
      codigo_grupo_financeiro nil
      titulo nil
    end
  end
end
