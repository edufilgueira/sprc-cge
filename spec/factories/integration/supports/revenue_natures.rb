FactoryBot.define do
  factory :integration_supports_revenue_nature, class: 'Integration::Supports::RevenueNature' do
    sequence(:codigo) { |n| "#{n}" }
    sequence(:descricao) { |n| "Natureza da Receita #{n}" }
    year Date.today.year
    trait :invalid do
      codigo nil
      descricao nil
    end
  end
end
