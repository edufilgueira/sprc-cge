
require 'rails_helper'

describe Operator::Tickets::TransferOrgansController do

  let(:user) { create(:user, :operator) }

  before { sign_in(user) }

  describe 'new' do

    context 'sou tickets' do
      let(:organ) { create(:executive_organ) }
      let(:ticket) { create(:ticket, created_by: user, organ: organ, unknown_organ: false, ticket_type: :sou) }

      before { get(:new, params: { ticket_id: ticket, id: ticket }) && ticket.reload }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('operator.tickets.index.sou.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sou) },
          { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sou) },
          { title: I18n.t('operator.tickets.transfer_organs.new.title.sou'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end

    context 'sic tickets' do
      let(:organ) { create(:executive_organ) }
      let(:ticket) { create(:ticket, created_by: user, organ: organ, unknown_organ: false, ticket_type: :sic) }

      before { get(:new, params: { ticket_id: ticket, id: ticket }) && ticket.reload }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('operator.tickets.index.sic.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sic) },
          { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sic) },
          { title: I18n.t('operator.tickets.transfer_organs.new.title.sic'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end

  describe 'create' do
    context 'sou tickets' do
      let(:organ) { create(:executive_organ) }
      let(:ticket) { create(:ticket, created_by: user, organ: organ, unknown_organ: false, ticket_type: :sou) }
      let(:invalid_ticket) do
        ticket.organ = nil
        ticket
      end
      let(:invalid_ticket_params) { { ticket_id: ticket, id: ticket, ticket: invalid_ticket.attributes } }

      before { ticket.reload }
      before { get(:new, params: invalid_ticket_params) }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('operator.tickets.index.sou.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sou) },
          { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sou) },
          { title: I18n.t('operator.tickets.transfer_organs.new.title.sou'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end

    context 'sic tickets' do
      let(:organ) { create(:executive_organ) }
      let(:ticket) { create(:ticket, created_by: user, organ: organ, unknown_organ: false, ticket_type: :sic) }
      let(:invalid_ticket) do
        ticket.organ = nil
        ticket
      end
      let(:invalid_ticket_params) { { ticket_id: ticket, id: ticket, ticket: invalid_ticket.attributes } }

      before { ticket.reload }
      before { get(:new, params: invalid_ticket_params) }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('operator.tickets.index.sic.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sic) },
          { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sic) },
          { title: I18n.t('operator.tickets.transfer_organs.new.title.sic'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end
end
