require 'rails_helper'

describe Operator::Tickets::EmailRepliesController do
  let(:user) { create(:user, :operator_sectoral) }
  let(:ticket) { create(:ticket, :with_parent) }

  describe 'edit' do

    before { sign_in(user) && get(:edit, params: { ticket_id: ticket }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.tickets.index.sou.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sou) },
        { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sou) },
        { title: I18n.t('operator.tickets.email_replies.edit.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
