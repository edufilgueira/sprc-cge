FactoryBot.define do
  factory :page_series_datum_translation, class: 'Page::SeriesDatum::Translation' do
    title "MyString"

    locale { I18n.locale }
  end
end
