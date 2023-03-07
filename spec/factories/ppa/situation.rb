FactoryBot.define do
  factory :ppa_situation, class: 'PPA::Situation' do

    description { 'Situação' }
    
    sequence(:isn_solucao) { |n| n*100 }

  end
end
