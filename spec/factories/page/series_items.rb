FactoryBot.define do
  factory :page_series_item, class: 'Page::SeriesItem' do
    title "2010"
    value 10.5
    page_series_datum
  end
end
