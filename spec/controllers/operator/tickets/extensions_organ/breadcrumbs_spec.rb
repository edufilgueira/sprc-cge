require 'rails_helper'

describe Operator::Tickets::ExtensionsOrganController do

  let(:user) { create(:user, :operator_sectoral) }

  before { sign_in(user) }

  describe 'new' do
    let(:ticket) { create(:ticket, created_by: user) }

    before { get(:new, params: { ticket_id: ticket }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.tickets.index.sou.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sou) },
        { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sou) },
        { title: I18n.t('operator.tickets.extensions_organ.new.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  describe 'create' do
    let(:ticket) { create(:ticket, created_by: user, ticket_type: :sou) }
    before { post(:create, params: { ticket_id: ticket, extension: { } }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.tickets.index.sou.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sou) },
        { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sou) },
        { title: I18n.t('operator.tickets.extensions_organ.new.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
