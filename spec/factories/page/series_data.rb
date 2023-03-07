FactoryBot.define do
  factory :page_series_datum, class: 'Page::SeriesDatum' do
    title "Serie 1"
    series_type :column
    page_chart
  end
end
