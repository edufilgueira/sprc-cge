FactoryBot.define do
  factory :ppa_plan, class: 'PPA::Plan' do

    transient do
      base_date { Date.today.beginning_of_year }
    end

    trait :past do
      base_date { Date.today.beginning_of_year - 1.year }
    end

    trait :future do
      base_date { Date.today.beginning_of_year + 1.year }
    end

    trait :elaborating do
      status { 0 }
    end

    trait :monitoring do
      status { 1 }
    end

    trait :revising do
      status { 3 }
    end

    start_year        { base_date.year }
    end_year          { start_year + 3 }
  end
end
