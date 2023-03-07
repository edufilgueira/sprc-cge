require 'refile/file_double'

FactoryBot.define do
  factory :attachment do

    document { Refile::FileDouble.new("test", "logo.png", content_type: "image/png") }

    association :attachmentable, factory: 'ticket'
    title 'Nome do Arquivo'
    imported_at { Date.current }
  end
end
