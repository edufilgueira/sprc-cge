FactoryBot.define do
  factory :ppa_voting, class: 'PPA::Voting' do

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