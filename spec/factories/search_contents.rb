FactoryBot.define do
  factory :search_content do
    sequence(:title) { |n| "Busca #{n}" }
    description 'Descrição'
    content 'conteúdo buscável'
    link "http://localhost:3000/"

    trait :invalid do
      title ''
      content ''
      link ''
    end
  end
end
