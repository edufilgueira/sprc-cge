require 'rails_helper'

describe PagesHelper do

  it 'parents_menu_title_for_select' do
    page = create(:page, :with_parent, menu_title: 'menu title')
    page2 = create(:page, :with_parent, menu_title: 'menu title 2')

    expected_hash = [
      [page.parent.menu_title, page.parent.id],
      [page2.parent.menu_title, page2.parent.id]
    ].sort

    expect(scoped_parents_menu_title_for_select(page)).to eq(expected_hash)
  end

  it 'status_for_select' do
    expected = [
      [ I18n.t("boolean.true"), :active ],
      [ I18n.t("boolean.false"), :inactive ]
    ]

    expect(page_status_for_select).to eq(expected)
  end

  it 'series_type_for_select' do
    expected = Page::SeriesDatum.series_types.keys.map do |key|
      [Page::SeriesDatum.human_attribute_name("series_type.#{key}"), key]
    end

    expect(series_type_for_select).to eq(expected)
  end

  it 'page_attachments_years_for_select' do
    page = create(:page)
    attachment_1 = create(:page_attachment, page: page, imported_at: 1.year.ago)
    attachment_2 = create(:page_attachment, page: page, imported_at: Date.current)
    create(:page_attachment, page: page, imported_at: Date.current)

    expected = [attachment_2.imported_at.year, attachment_1.imported_at.year]

    expect(page_attachments_years_for_select(page)).to eq(expected)
  end
end
