FactoryBot.define do
  factory :integration_contracts_situation, class: 'Integration::Contracts::Situation' do
    description 'AGUARDANDO PUBLICAÇÃO DO ADITIVO'
    
    trait :waiting_additive_publication do
      description 'AGUARDANDO PUBLICAÇÃO DO ADITIVO'
    end

    trait :concluded do
      description 'CONCLUÍDO'
    end

    trait :concluded_with_debts do
      description 'CONCLUÍDO COM DÍVIDA'
    end
  end
end
