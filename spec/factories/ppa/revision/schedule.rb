FactoryBot.define do
  factory :ppa_revision_schedule, class: 'PPA::Revision::Schedule' do

    association :plan, factory: :ppa_plan
    start_in Date.today
    end_in Date.tomorrow
    stage :process_evaluation

    trait :out do
      start_in Date.today-1.year
      end_in Date.tomorrow-1.year
    end

  end
end
