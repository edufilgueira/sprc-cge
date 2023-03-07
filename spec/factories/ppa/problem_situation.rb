FactoryBot.define do
  factory :ppa_problem_situation, class: 'PPA::ProblemSituation' do

    association :theme, factory: :ppa_theme
    association :axis, factory: :ppa_axis
    association :region, factory: :ppa_region
    association :situation, factory: :ppa_situation
     
    sequence(:isn_solucao_problema) { |n| n*100 }

  end
end
