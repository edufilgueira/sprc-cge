require 'rails_helper'

describe Operator::Tickets::AppealsController do

  let(:user) { create(:user, :operator_call_center) }
  let(:ticket) { create(:ticket, :sic, :replied, call_center_responsible: user) }

  describe 'new' do
    before { get(:new, params: { ticket_id: ticket }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.tickets.index.sic.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sic) },
        { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sic) },
        { title: I18n.t('operator.tickets.appeals.new.title'), url: '' }
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
        { title: I18n.t('operator.tickets.appeals.new.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
