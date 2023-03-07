require 'rails_helper'

describe Notifier::Appeal do

  # usuários com notificações habilidatas
  let!(:user) { create(:user, :user) }
  let!(:operator_cge) { create(:user, :operator_cge) }

  let(:ticket) { create(:ticket) }

  let(:service) { Notifier::Appeal.new(ticket.id) }

  let(:url_helpers) { Rails.application.routes.url_helpers }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Notifier::Appeal).to receive(:new).with(ticket.id) { service }
      allow(service).to receive(:call)
      Notifier::Appeal.call(ticket.id)

      expect(Notifier::Appeal).to have_received(:new).with(ticket.id)
      expect(service).to have_received(:call)
    end
  end

  describe 'initialization' do
    it 'responds to notification' do
      expect(service.ticket).to be_an_instance_of(Ticket)
    end
  end

  describe 'call' do

    # TICKET
    context 'ticket' do
      let(:child) { create(:ticket, :with_parent, :sic) }
      let(:parent) { child.parent }
      let(:service) { Notifier::Appeal.new(parent.id) }
      let(:notification_operator) { Mailboxer::Notification.first }

      before { service.call }

      it { expect(Mailboxer::Notification.count).to eq(1) }

      it 'send to operator' do
        expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: parent.id)

        expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.appeal.operator.subject', protocol: parent.parent_protocol))
        expect(notification_operator.body).to eq(I18n.t('shared.notifications.messages.appeal.operator.body', protocol: parent.parent_protocol, url: expected_url))
        expect(operator_cge.mailbox.notifications.include?(notification_operator)).to be_truthy
      end

    end
  end
end
