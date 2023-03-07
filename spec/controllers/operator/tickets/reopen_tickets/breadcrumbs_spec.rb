require 'rails_helper'

describe Operator::Tickets::ReopenTicketsController do

  let(:user) { create(:user, :operator_call_center) }
  let(:ticket) { create(:ticket, :replied, call_center_responsible: user) }

  describe 'sou' do
    describe 'new' do
      before { get(:new, params: { ticket_id: ticket }) }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('operator.tickets.index.sou.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sou) },
          { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sou) },
          { title: I18n.t('operator.tickets.reopen_tickets.new.sou.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end

    describe 'create' do
      before { post(:create, params: { ticket_id: ticket }) }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('operator.tickets.index.sou.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sou) },
          { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sou) },
          { title: I18n.t('operator.tickets.reopen_tickets.new.sou.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end

  describe 'sic' do
    let(:ticket) { create(:ticket, :sic, :replied, call_center_responsible: user) }

    describe 'new' do
      before { get(:new, params: { ticket_id: ticket }) }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('operator.tickets.index.sic.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sic) },
          { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sic) },
          { title: I18n.t('operator.tickets.reopen_tickets.new.sic.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end

    describe 'create' do
      before { post(:create, params: { ticket_id: ticket }) }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('operator.tickets.index.sic.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sic) },
          { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sic) },
          { title: I18n.t('operator.tickets.reopen_tickets.new.sic.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end
end
