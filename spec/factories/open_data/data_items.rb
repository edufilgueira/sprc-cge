FactoryBot.define do
  factory :data_item, class: 'OpenData::DataItem'  do

    sequence(:title) {|n| "Item de dados abertos #{n}"}
    description "Descrição do item de dados abertos"
    data_item_type :webservice
    response_path 'path/to/array'
    wsdl 'http://example.com?wsdl'
    parameters 'foo=bar'
    operation 'authenticate'
    headers_soap_action ''
    status :status_success
    document_public_filename 'Arquivo de dados abertos'
    document_format 'csv'

    association :data_set

    trait :webservice do
    end

    trait :receitas do
      response_path "mes_exercicio_response/saldos_orcamentarios/saldo_orcamentario"
      parameters "mes=CURRENT_MONTH"
      operation :mes_exercicio
    end

    trait :countries do
      response_path "get_countries_response/get_countries_result"
      parameters ""
      operation :get_countries
    end

    trait :file do
      data_item_type :file
      document { Refile::FileDouble.new("test", "test.csv", content_type: "text/csv") }
    end

    trait :invalid do
      title nil
    end
  end
end
