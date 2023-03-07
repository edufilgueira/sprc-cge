require 'rails_helper'

describe Transparency::PublicTicketsController do

  let(:public_ticket) { create(:ticket, :public_ticket) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do

      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t("transparency.public_tickets.index.#{public_ticket.ticket_type}.title"), url: '' },
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { get(:show, params: { id: public_ticket }) }

    it 'breadcrumbs' do

      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t("transparency.public_tickets.index.#{public_ticket.ticket_type}.title"), url: transparency_public_tickets_path(ticket_type: public_ticket.ticket_type) },
        { title: public_ticket.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end

