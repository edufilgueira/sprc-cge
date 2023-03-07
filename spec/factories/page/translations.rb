FactoryBot.define do
  factory :page_translation, class: 'Page::Translation' do
    title "MyString"
    content "MyText"
    sequence(:menu_title) { |n| "menu title-#{n}" }

    locale { I18n.locale }
  end
end
