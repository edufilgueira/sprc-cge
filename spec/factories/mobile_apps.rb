FactoryBot.define do
  factory :mobile_app do
    sequence(:name) {|n| "APP-#{n}"}
    description "MyText"
    official false

    icon { Refile::FileDouble.new("test", "icon.png", content_type: "image/png") }

    mobile_tags { create_list(:mobile_tag, 1) }

    trait :invalid do
      name nil
    end
  end
end
