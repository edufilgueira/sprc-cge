FactoryBot.define do
  factory :ppa_region, class: 'PPA::Region' do
    sequence(:code) { |n| n.to_s }
    sequence(:name) { |n| "Region - #{n}" }

    trait :invalid do
      name nil
    end
  end
end
