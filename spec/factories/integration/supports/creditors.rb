FactoryBot.define do
  factory :integration_supports_creditor, class: 'Integration::Supports::Creditor' do
    bairro "Centro"
    cep "63570000"
    sequence(:codigo) { |c| "#{c}" }
    codigo_contribuinte "X"
    codigo_distrito nil
    codigo_municipio "2300804"
    codigo_nit nil
    codigo_pis_pasep nil
    complemento "RUA JOÃO BATISTA ARRAIS, Nº 08"
    cpf_cnpj "07594500000148"
    data_atual "25/09/2017"
    data_cadastro "25/09/2017"
    email "prefeituramunicipalantonina@hotmail.com"
    logradouro "ROSENO DE MATOS"
    nome "PREFEITURA MUNICIPAL DE ANTONINA DO NORTE"
    nome_municipio "Antonina do Norte"
    sequence(:numero) { |n| "#{n}" }
    status "Ativo"
    telefone_contato "8835251322"
    uf "CE"

    trait :invalid do
      nome nil
    end
  end
end
