FactoryBot.define do
  factory :rede_ouvir_organ do
    sequence(:acronym) {|n| "ORG-#{n}"}
    name 'Prefeitura de Fortaleza'
    description 'Prefeitura de Fortaleza'

    trait :invalid do
      name ''
    end

    trait :cge do
      acronym 'CGE'
      name 'Rede Ouvir - Governo Estadual'
      description 'Rede Ouvir - Governo Estadual'
    end
  end
end
