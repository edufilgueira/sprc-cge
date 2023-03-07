require 'rails_helper'

describe GlobalSearcher::ExecutiveOmbudsmanSearcher do
  include ActionView::Helpers::SanitizeHelper

  let(:url_helper) do
    Rails.application.routes.url_helpers
  end

  describe 'executive_ombudsman' do
    it 'searchs by title and contact_name' do
      found_executive_ombudsman = create(:executive_ombudsman, title: '1234', contact_name: '1234')
      not_executive_ombudsman = create(:executive_ombudsman, title: '5678', contact_name: '5678')

      result = GlobalSearcher::ExecutiveOmbudsmanSearcher.call('23')

      expected_description = {
        contact_name: found_executive_ombudsman.contact_name,
        phone: found_executive_ombudsman.phone,
        email: found_executive_ombudsman.email,
        address: found_executive_ombudsman.address,
        operating_hours: found_executive_ombudsman.operating_hours
      }

      # A página de ouvidorias não tem show. Mandamos o usuário para a index com
      # a busca contendo o nome todo da ouvidoria.

      expected_link = url_helper.transparency_sou_executive_ombudsmen_path(search: found_executive_ombudsman.title, locale: I18n.locale)

      expected = {
        id: 'ExecutiveOmbudsman',

        results: [{
          title: found_executive_ombudsman.title,
          description: expected_description,
          link: expected_link
        }],

        show_more_url: url_helper.transparency_sou_executive_ombudsmen_path(search: '23', anchor: 'search', locale: I18n.locale)
      }

      expect(result).to eq(expected)
    end

    it 'limits to 5 results' do
      found_executive_ombudsman = create(:executive_ombudsman, title: '1234', contact_name: '1234')
      another_executive_ombudsman = create(:executive_ombudsman, title: '1234', contact_name: '1234')

      stub_const('GlobalSearcher::Base::SEARCH_LIMIT', 1)

      expect(GlobalSearcher::ExecutiveOmbudsmanSearcher::SEARCH_LIMIT).to eq(1)

      expect(GlobalSearcher::ExecutiveOmbudsmanSearcher.call('23')[:results].count).to eq(1)
    end
  end
end
