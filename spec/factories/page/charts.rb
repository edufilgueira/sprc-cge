FactoryBot.define do
  factory :page_chart, class: 'Page::Chart' do
    title "Gráfico de %"
    description "Descrição para acessibilidade"
    unit '%'
    page
  end
end
