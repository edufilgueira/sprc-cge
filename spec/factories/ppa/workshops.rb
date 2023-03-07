FactoryBot.define do
  factory :ppa_workshop, class: 'PPA::Workshop' do
    transient do
      base_date { Date.tomorrow }
    end

    plan { PPA::Plan.first || create(:ppa_plan) }
    name "Awesome Workshop"
    start_at { base_date }
    end_at { base_date + 2.hours }
    association :city, factory: :ppa_city
    address "Some place, number 123"
    participants_count 1
    link 'somelink.com.br'

    trait :past do
      start_at { Date.yesterday }
      end_at { Date.yesterday + 2.hours }
    end

  end
end
