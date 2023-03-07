FactoryBot.define do
  factory :page_chart_translation, class: 'Page::Chart::Translation' do
    title "Gráfico de %"
    description "Descrição para acessibilidade"
    unit '%'

    locale { I18n.locale }
  end
end
