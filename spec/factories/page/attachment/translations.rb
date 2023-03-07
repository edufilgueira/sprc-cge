FactoryBot.define do
  factory :page_attachment_translation, class: 'Page::Attachment::Translation' do
    title "MyString"

    locale { I18n.locale }
  end
end
