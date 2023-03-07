require 'rails_helper'

describe PublicTicketNotificationService do
  context 'public_ticket notification' do
    let!(:public_ticket) { create(:ticket, :public_ticket) }
    let!(:ticket_subscription) { create(:ticket_subscription, :confirmed, ticket: public_ticket) }
    let!(:ticket_log) { create(:ticket_log, ticket: public_ticket) }

    it 'call notifier' do
      service = double
      allow(Notifier::PublicTicket).to receive(:delay) { service }
      allow(service).to receive(:call)

      PublicTicketNotificationService.call(ticket_log.id, ticket_log.action)

      expect(service).to have_received(:call).with(ticket_log.id)
    end

    context 'call email' do
      it 'params' do
        service = double
        allow(TicketMailer).to receive(:ticket_subscriber_notification) { service }
        allow(service).to receive(:deliver_later)

        PublicTicketNotificationService.call(ticket_log.id, ticket_log.action)

        expect(TicketMailer).to have_received(:ticket_subscriber_notification).with(ticket_subscription.id, ticket_log.action)
        expect(service).to have_received(:deliver_later)
      end

      it 'send all emails' do
        create(:ticket_subscription, :confirmed, ticket: public_ticket)
        create(:ticket_subscription, :confirmed, ticket: public_ticket)
        create(:ticket_subscription, :unconfirmed, ticket: public_ticket)

        count_ticket_subscription = TicketSubscription.where(ticket: public_ticket, confirmed_email: true).count

        service = double
        allow(TicketMailer).to receive(:ticket_subscriber_notification) { service }
        allow(service).to receive(:deliver_later)

        PublicTicketNotificationService.call(ticket_log.id, ticket_log.action)

        expect(TicketMailer).to have_received(:ticket_subscriber_notification).exactly(count_ticket_subscription).times
        expect(service).to have_received(:deliver_later).exactly(count_ticket_subscription).times
      end
    end
  end
end
