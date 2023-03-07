require 'rails_helper'

describe Platform::Tickets::ReopenTicketsController do

  let(:user) { create(:user) }
  let(:ticket) { create(:ticket, :replied, created_by: user) }

  describe 'sou' do
    describe 'new' do
      before { get(:new, params: { ticket_id: ticket }) }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('platform.tickets.index.sou.breadcrumb_title'), url: platform_tickets_path(ticket_type: :sou) },
          { title: ticket.title, url: platform_ticket_path(ticket, ticket_type: :sou) },
          { title: I18n.t('platform.tickets.reopen_tickets.new.sou.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end

    describe 'create' do
      before { post(:create, params: { ticket_id: ticket }) }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('platform.tickets.index.sou.breadcrumb_title'), url: platform_tickets_path(ticket_type: :sou) },
          { title: ticket.title, url: platform_ticket_path(ticket, ticket_type: :sou) },
          { title: I18n.t('platform.tickets.reopen_tickets.new.sou.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end

  describe 'sic' do
    let(:ticket) { create(:ticket, :sic, :replied, created_by: user) }
    describe 'new' do
      before { get(:new, params: { ticket_id: ticket }) }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('platform.tickets.index.sic.breadcrumb_title'), url: platform_tickets_path(ticket_type: :sic) },
          { title: ticket.title, url: platform_ticket_path(ticket, ticket_type: :sic) },
          { title: I18n.t('platform.tickets.reopen_tickets.new.sic.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end

    describe 'create' do
      before { post(:create, params: { ticket_id: ticket }) }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('platform.tickets.index.sic.breadcrumb_title'), url: platform_tickets_path(ticket_type: :sic) },
          { title: ticket.title, url: platform_ticket_path(ticket, ticket_type: :sic) },
          { title: I18n.t('platform.tickets.reopen_tickets.new.sic.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end
end
