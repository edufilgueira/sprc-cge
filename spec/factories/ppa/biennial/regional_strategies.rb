FactoryBot.define do
  factory :ppa_biennial_regional_strategy, class: 'PPA::Biennial::RegionalStrategy' do

    association :strategy, factory: :ppa_strategy
    association :region,   factory: :ppa_region

    start_year { Date.today.year }
    end_year   { start_year.present? ? start_year + 1 : nil }
    priority   { PPA::Biennial::RegionalStrategy.priorities.keys.sample }

    # traits for each priority
    PPA::Biennial::RegionalStrategy.priorities.keys.each do |priority_key|
      trait priority_key.to_sym do
        priority priority_key
      end
    end

    trait :priority do
      priority :prioritized
    end

    trait :invalid do
      strategy nil
      region nil
      start_year nil
    end

  end
end
