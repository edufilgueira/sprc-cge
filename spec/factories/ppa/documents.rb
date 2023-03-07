require 'refile/file_double'

FactoryBot.define do
  factory :ppa_document, class: 'PPA::Document' do
    attachment { Refile::FileDouble.new("test", "report.pdf", content_type: "pdf") }
    association :uploadable, factory: :ppa_workshop

    trait :invalid do
      attachment nil
    end
  end
end
