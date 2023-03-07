FactoryBot.define do
  factory :page_series_item_translation, class: 'Page::SeriesItem::Translation' do
    title "MyString"

    locale { I18n.locale }
  end
end
