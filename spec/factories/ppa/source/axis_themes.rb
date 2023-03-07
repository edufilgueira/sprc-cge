# XXX factory copiada de sprc-data
FactoryBot.define do
  factory :ppa_source_axis_theme, class: 'PPA::Source::AxisTheme' do
    sequence(:codigo_eixo) { |n| n.to_s } # '1'
    sequence(:descricao_eixo) { |n| "EIXO #{n}" } # 'CEARÁ DA GESTÃO DEMOCRÁTICA POR RESULTADOS'
    sequence(:codigo_tema) { |n| "#{codigo_eixo}.#{n}" } # '1.01'
    sequence(:descricao_tema) { |n| "TEMA #{n}" } # '-'
    descricao_tema_detalhado nil

    trait :invalid do
      codigo_eixo nil
    end
  end
end
