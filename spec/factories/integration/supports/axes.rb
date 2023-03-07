FactoryBot.define do
  factory :integration_supports_axis, class: 'Integration::Supports::Axis' do
    codigo_eixo "1"
    descricao_eixo "CEARÁ DA GESTÃO DEMOCRÁTICA POR RESULTADOS"

    trait :invalid do
      codigo_eixo nil
    end
  end
end
