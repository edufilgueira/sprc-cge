FactoryBot.define do
  factory :search_content_translation, class: 'SearchContent::Translation' do
    sequence(:title) { |n| "Busca #{n}" }
    description 'Descrição'
    content 'conteúdo buscável'

    locale { I18n.locale }
  end
end
