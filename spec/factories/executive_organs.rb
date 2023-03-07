FactoryBot.define do
  factory :executive_organ do

    sequence(:acronym) {|n| "ORG-#{n}"}
    sequence(:name) {|n| "Controladoria e Ouvidoria Geral do Estado-#{n}"}
    description "Controladoria e Ouvidoria Geral do Estado"

    sequence(:code)

    trait :invalid do
      name nil
    end

    trait :cge do
      acronym 'CGE'
    end

    trait :cosco do
      acronym 'COSCO'
    end

    trait :dpge do
      acronym 'DPGE'
    end

    trait :with_subnet do
      subnet true
    end

    trait :ignore_cge_validation do
      ignore_cge_validation true
    end

    trait :disabled do
      disabled_at Time.now
    end

    trait :couvi do
      acronym 'COUVI'
    end
  end
end
