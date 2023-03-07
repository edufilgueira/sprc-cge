require 'rails_helper'

describe Operator::Tickets::AttendanceResponsesController do

  let(:user) { create(:user, :operator) }

  let(:ticket) { create(:ticket, created_by: user, ticket_type: :sou) }

  before { sign_in(user) }

  describe 'new' do
    before { get(:new, params: { ticket_id: ticket }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.tickets.index.sou.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sou) },
        { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sou) },
        { title: I18n.t('operator.tickets.attendance_responses.new.title', ticket_title: ticket.title), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  describe 'failure' do
    before { post(:failure, params: { ticket_id: ticket }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.tickets.index.sou.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sou) },
        { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sou) },
          { title: I18n.t('operator.tickets.attendance_responses.new.title', ticket_title: ticket.title), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  describe 'success' do
    before { post(:success, params: { ticket_id: ticket }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.tickets.index.sou.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sou) },
        { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sou) },
          { title: I18n.t('operator.tickets.attendance_responses.new.title', ticket_title: ticket.title), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
