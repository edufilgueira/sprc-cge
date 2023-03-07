FactoryBot.define do
  factory :ppa_attachment, class: 'PPA::Attachment' do
    attachment_filename 'nice_pic.png'
    attachment_content_type 'image/png'
  end
end
