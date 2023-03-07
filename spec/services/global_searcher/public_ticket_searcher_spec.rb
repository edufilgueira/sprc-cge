require 'rails_helper'

describe GlobalSearcher::PublicTicketSearcher do
  include ActionView::Helpers::SanitizeHelper
  include OrgansHelper

  let(:url_helper) do
    Rails.application.routes.url_helpers
  end

  describe 'ticket' do
    it 'searchs by title and content' do
      found_ticket = create(:ticket, :public_ticket, protocol: '999999', description: "<p>#{'A'*(GlobalSearcher::Base::DESCRIPTION_TRUNCATE_SIZE + 10)}</p>")
      not_ticket = create(:ticket, :public_ticket, description: 'bla')

      non_published_ticket = create(:ticket, :public_ticket, protocol: '9999999', description: "<p>#{'A'*(GlobalSearcher::Base::DESCRIPTION_TRUNCATE_SIZE + 10)}</p>")

      non_published_ticket.update_column(:published, false)

      result = GlobalSearcher::PublicTicketSearcher.call(found_ticket.parent_protocol)

      expected_title = "#{found_ticket.protocol} - #{acronym_organs_list(found_ticket)} - (#{found_ticket.internal_status_str})"
      full_description = found_ticket.description
      expected_description = strip_tags(full_description)&.truncate(GlobalSearcher::Base::DESCRIPTION_TRUNCATE_SIZE)

      expected = {
        id: 'Ticket',

        results: [{
          title: expected_title,
          description: expected_description,
          link: url_helper.transparency_public_ticket_path(found_ticket, locale: I18n.locale)
        }],

        show_more_url: url_helper.transparency_public_tickets_path(search: found_ticket.parent_protocol, anchor: 'search', locale: I18n.locale)
      }

      expect(result).to eq(expected)
    end

    it 'limits to 5 results' do
      found_ticket = create(:ticket, :public_ticket, protocol: '999999', description: "<p>#{'A'*(GlobalSearcher::Base::DESCRIPTION_TRUNCATE_SIZE + 10)}</p>")

      another_ticket = create(:ticket, :public_ticket, protocol: '1999999', description: "<p>#{'A'*(GlobalSearcher::Base::DESCRIPTION_TRUNCATE_SIZE + 10)}</p>")

      stub_const('GlobalSearcher::Base::SEARCH_LIMIT', 1)

      expect(GlobalSearcher::PublicTicketSearcher::SEARCH_LIMIT).to eq(1)

      expect(GlobalSearcher::PublicTicketSearcher.call('999999')[:results].count).to eq(1)
    end
  end
end
