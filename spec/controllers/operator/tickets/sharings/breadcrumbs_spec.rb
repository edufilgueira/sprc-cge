require 'rails_helper'

describe Operator::Tickets::SharingsController do

  let(:user) { create(:user, :operator) }

  before { sign_in(user) }

  describe 'new' do

    context 'sou tickets' do
      let(:ticket) { create(:ticket, created_by: user, ticket_type: :sou) }

      before { get(:new, params: { ticket_id: ticket }) && ticket.reload }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('operator.tickets.index.sou.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sou) },
          { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sou) },
          { title: I18n.t('operator.tickets.sharings.new.sou.breadcrumb.title.add'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end

    context 'sic tickets' do
      let(:ticket) { create(:ticket, created_by: user, ticket_type: :sic) }

      before { get(:new, params: { ticket_id: ticket }) && ticket.reload }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('operator.tickets.index.sic.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sic) },
          { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sic) },
          { title: I18n.t('operator.tickets.sharings.new.sic.breadcrumb.title.add'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end

    context 'sharing ticket parent' do
      let(:ticket) { create(:ticket, created_by: user, ticket_type: :sou) }

      before { get(:new, params: { ticket_id: ticket }) && ticket.reload }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('operator.tickets.index.sou.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sou) },
          { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sou) },
          { title: I18n.t('operator.tickets.sharings.new.sou.breadcrumb.title.add'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end

    context 'sharing ticket with parent' do
      let(:ticket) { create(:ticket, :with_parent, created_by: user, ticket_type: :sou) }

      before { get(:new, params: { ticket_id: ticket }) && ticket.reload }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('operator.tickets.index.sou.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sou) },
          { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sou) },
          { title: I18n.t('operator.tickets.sharings.new.sou.breadcrumb.title.share'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end
end
