FactoryBot.define do
  factory :page_attachment, class: 'Page::Attachment' do
    document { Refile::FileDouble.new("test", "attachment.png", content_type: "image/png") }

    imported_at { Date.current }
    title 'Nome do Arquivo'
    page
  end
end
