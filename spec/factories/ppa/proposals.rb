FactoryBot.define do
  factory :ppa_proposal, class: 'PPA::Proposal' do

    association :city,  factory: :ppa_city
    association :plan,  factory: :ppa_plan
    association :theme, factory: :ppa_theme
    association :region, factory: :ppa_region
    user

    # optional association (with randomness)
    objective { build(:ppa_objective) if rand(11) > 5 }

    strategy "A Strategy"
    justification "My justification for this proposal"

    trait :invalid do
      plan nil
      city nil
      user nil
    end
  end
end
