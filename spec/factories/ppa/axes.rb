FactoryBot.define do
  factory :ppa_axis, class: 'PPA::Axis' do
    sequence(:code) { |n| "AX-#{n}" }
    sequence(:name) { |n| "PPA Axis #{n}" }

    trait :invalid do
      code nil
    end
  end
end
