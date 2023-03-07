FactoryBot.define do
  factory :integration_supports_theme, class: 'Integration::Supports::Theme' do
    codigo_tema "1.01"
    descricao_tema "GESTÃO FISCAL"

    trait :invalid do
      codigo_tema nil
    end
  end
end
