require 'rails_helper'

describe GlobalSearcher::PageSearcher do
  include ActionView::Helpers::SanitizeHelper

  let(:url_helper) do
    Rails.application.routes.url_helpers
  end

  let!(:found_page) { create(:page, title: '12345', content: "<p>#{'A'*(GlobalSearcher::Base::DESCRIPTION_TRUNCATE_SIZE + 10)}</p>") }
  let!(:another_page) { create(:page, title: '6789') }

  let(:expected_result) do
    full_content = found_page.content
    expected_description = strip_tags(full_content)&.truncate(GlobalSearcher::Base::DESCRIPTION_TRUNCATE_SIZE)

    expected_result = {
      id: 'Page',

      results: [{
        title: found_page.title,
        description: expected_description,
        link: url_helper.transparency_page_path(found_page, locale: I18n.locale)
      }],

      show_more_url: url_helper.transparency_pages_path(search: search_term, anchor: 'search', locale: I18n.locale)
    }
  end

  describe 'title' do
    let(:search_term) { found_page.title }

    it 'search' do
      result = GlobalSearcher::PageSearcher.call(found_page.title)
      expect(result).to eq(expected_result)
    end
  end

  it 'limits to 5 results' do
    stub_const('GlobalSearcher::Base::SEARCH_LIMIT', 1)

    expect(GlobalSearcher::PageSearcher::SEARCH_LIMIT).to eq(1)

    expect(GlobalSearcher::PageSearcher.call('23')[:results].count).to eq(1)
  end
end
