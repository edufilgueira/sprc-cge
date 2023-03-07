FactoryBot.define do
  factory :ppa_proposal_theme, class: 'PPA::ProposalTheme' do

    association :plan,  factory: :ppa_plan
    association :region, factory: :ppa_region

    start_in "2018-03-18"
    end_in "2018-03-19"
    
    trait :invalid do
      plan nil
      region nil      
    end
  end
end
