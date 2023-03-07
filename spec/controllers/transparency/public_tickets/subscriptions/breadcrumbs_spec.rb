require 'rails_helper'

describe Transparency::PublicTickets::SubscriptionsController do

  let(:ticket) { create(:ticket, :public_ticket) }

  context 'new' do
    before { get(:new, params: { public_ticket_id: ticket}) }

    it 'breadcrumbs' do

      expected = [
        { title: I18n.t("transparency.public_tickets.index.#{ticket.ticket_type}.title"), url: transparency_public_tickets_path(ticket_type: ticket.ticket_type) },
        { title: I18n.t("transparency.public_tickets.subscriptions.breadcrumbs.ticket.#{ticket.ticket_type}", protocol: ticket.protocol), url: transparency_public_ticket_path(ticket) },
        { title: I18n.t("transparency.public_tickets.subscriptions.new.title.#{ticket.ticket_type}"), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'edit' do
    let(:ticket_subscription) { create(:ticket_subscription, :confirmed)}

    before { get(:edit, params: { public_ticket_id: ticket, id: ticket_subscription}) }

    it 'breadcrumbs' do

      expected = [
        { title: I18n.t("transparency.public_tickets.index.#{ticket.ticket_type}.title"), url: transparency_public_tickets_path(ticket_type: ticket.ticket_type) },
        { title: I18n.t("transparency.public_tickets.subscriptions.breadcrumbs.ticket.#{ticket.ticket_type}", protocol: ticket.protocol), url: transparency_public_ticket_path(ticket) },
        { title: I18n.t("transparency.public_tickets.subscriptions.new.title.#{ticket.ticket_type}"), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end

