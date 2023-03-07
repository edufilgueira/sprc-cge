FactoryBot.define do
  factory :data_set, class: 'OpenData::DataSet'  do

    sequence(:title) {|n| "Conjunto de dados abertos #{n}"}
    description "Descrição dos dados abertos"
    source_catalog "http://dadosabertos.gov.br"
    association :organ, factory: :integration_supports_organ
    author "Autoria do dado aberto"

    trait :invalid do
      title nil
      description nil
      source_catalog nil
      organ nil
      author nil
    end
  end
end
