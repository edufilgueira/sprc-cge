FactoryBot.define do
  factory :state do
    sequence(:code)  {|n| n }
    sequence(:acronym)  {|n| "ST-#{n}"}
    sequence(:name)     {|n| "Estado #{n}"}

    trait :default do
      acronym 'CE'
      name 'Ceará'
      # code 23 - isso eventualmente causaria colisão. Vamos nos ater à sigla CE.

      initialize_with { ::State.where(acronym: acronym).first_or_initialize }
    end

    trait :ceara do
      default
    end
  end
end
