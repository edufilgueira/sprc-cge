require 'rails_helper'

describe GlobalSearcher::SearchContentSearcher do
  include ActionView::Helpers::SanitizeHelper

  let(:url_helper) do
    Rails.application.routes.url_helpers
  end

  describe 'search_content' do
    it 'searchs by title and content' do
      found_search_content = create(:search_content, title: '1234', content: '1234', description: "<p>#{'A'*(GlobalSearcher::Base::DESCRIPTION_TRUNCATE_SIZE + 10)}</p>")
      not_search_content = create(:search_content, title: '5678', content: '5678')

      result = GlobalSearcher::SearchContentSearcher.call('23')
      full_description = found_search_content.description
      expected_description = strip_tags(full_description)&.truncate(GlobalSearcher::Base::DESCRIPTION_TRUNCATE_SIZE)

      expected = {
        id: 'SearchContent',

        results: [{
          title: found_search_content.title,
          description: expected_description,
          link: found_search_content.link
        }],

        show_more_url: url_helper.search_contents_path(search: '23', anchor: 'search', locale: I18n.locale)
      }

      expect(result).to eq(expected)
    end

    it 'limits to 5 results' do
      found_search_content = create(:search_content, title: '1234', content: '1234')
      another_search_content = create(:search_content, title: '1234', content: '1234')

      stub_const('GlobalSearcher::Base::SEARCH_LIMIT', 1)

      expect(GlobalSearcher::SearchContentSearcher::SEARCH_LIMIT).to eq(1)

      expect(GlobalSearcher::SearchContentSearcher.call('23')[:results].count).to eq(1)
    end
  end
end
