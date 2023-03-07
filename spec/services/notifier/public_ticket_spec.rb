require 'rails_helper'

describe Notifier::PublicTicket do
  let(:public_ticket) { create(:ticket, :public_ticket) }
  let(:users_follow) { create_list(:user, 2, :user) }
  let!(:subscribers) { users_follow.map{|u| create(:ticket_subscription, :confirmed, user: u, ticket: public_ticket) } }
  let!(:ticket_log) { create(:ticket_log, ticket: public_ticket) }

  let(:service) { Notifier::PublicTicket.new(ticket_log.id) }

  let(:url_helpers) { Rails.application.routes.url_helpers }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Notifier::PublicTicket).to receive(:new).with(ticket_log.id) { service }
      allow(service).to receive(:call)
      Notifier::PublicTicket.call(ticket_log.id)

      expect(Notifier::PublicTicket).to have_received(:new).with(ticket_log.id)
      expect(service).to have_received(:call)
    end
  end

  describe 'initialization' do
    it 'responds to notification' do
      expect(service.users).to match_array(users_follow)
    end
  end

  describe 'Notify following users from public ticket' do
    let(:notification) { Mailboxer::Notification.last }

    before { service.call }

    it 'send to user' do
      expected_url = url_helpers.url_for(controller: '/transparency/public_tickets', action: 'show', id: public_ticket.id)

      expect(notification.subject).to eq(I18n.t("shared.notifications.public_ticket.answer.#{public_ticket.ticket_type}.subject", protocol: public_ticket.parent_protocol))
      expect(notification.body).to eq(I18n.t("shared.notifications.public_ticket.answer.#{public_ticket.ticket_type}.body", protocol: public_ticket.parent_protocol, url: expected_url))

      expect(Mailboxer::Notification.count).to eq(users_follow.count)
    end
  end
end
