require 'refile/file_double'

FactoryBot.define do
  factory :ppa_photo, class: 'PPA::Photo' do
    attachment { Refile::FileDouble.new("test", "pic.png", content_type: "image/png") }
    association :uploadable, factory: :ppa_workshop

    trait :invalid do
      attachment nil
    end
  end
end
