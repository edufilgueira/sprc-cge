require 'rails_helper'

describe Notifier::Invalidate do

  let(:organ) { create(:executive_organ) }

  # usuários com notificações habilidatas
  let!(:user) { create(:user, :user) }
  let!(:operator_sectoral) { create(:user, :operator_sectoral, organ: organ) }
  let!(:operator_cge) { create(:user, :operator_cge) }

  let(:ticket) { create(:ticket) }

  let(:service) { Notifier::Invalidate.new(ticket.id, user.id) }

  let(:url_helpers) { Rails.application.routes.url_helpers }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Notifier::Invalidate).to receive(:new).with(ticket.id, user.id) { service }
      allow(service).to receive(:call)
      Notifier::Invalidate.call(ticket.id, user.id)

      expect(Notifier::Invalidate).to have_received(:new).with(ticket.id, user.id)
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
      let(:child) { create(:ticket, :with_parent, :sic, organ: organ) }
      let(:parent) { child.parent }
      let(:service) { Notifier::Invalidate.new(child.id, operator_sectoral.id) }
      let(:notification_operator) { Mailboxer::Notification.first }
      let(:notification_user) { Mailboxer::Notification.last }

      before { service.call }

      it 'send to user' do
        expected_url = url_helpers.url_for(controller: '/ticket_area/tickets', action: 'show', id: parent.id)

        expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.invalidate.ticket_area.subject.sic', protocol: parent.parent_protocol))
        expect(notification_user.body).to eq(I18n.t("shared.notifications.messages.invalidate.ticket_area.body.sic", user_name: operator_sectoral.name, protocol: parent.parent_protocol, url: expected_url))
        expect(parent.mailbox.notifications.include?(notification_user)).to be_truthy
      end

      it 'send to operator' do
        expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: parent.id)

        expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.invalidate.operator.subject.sic', protocol: parent.parent_protocol))
        expect(notification_operator.body).to eq(I18n.t("shared.notifications.messages.invalidate.operator.body.sic", user_name: operator_sectoral.name, protocol: parent.parent_protocol, url: expected_url))
        expect(operator_cge.mailbox.notifications.include?(notification_operator)).to be_truthy
      end
    end

    # PLATFORM
    context 'platform' do
      let(:ticket) { create(:ticket, created_by: user) }
      let(:service) { Notifier::Invalidate.new(ticket.id, operator_cge.id) }
      let(:notification_user) { Mailboxer::Notification.last }

      before { service.call }

      it 'send to user' do
        expected_url = url_helpers.url_for(controller: '/platform/tickets', action: 'show', id: ticket.id)

        expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.invalidate.platform.subject.sou', protocol: ticket.parent_protocol))
        expect(notification_user.body).to eq(I18n.t("shared.notifications.messages.invalidate.platform.body.sou", user_name: operator_cge.name, protocol: ticket.parent_protocol, url: expected_url))
        expect(user.mailbox.notifications.include?(notification_user)).to be_truthy
      end

    end
  end

end
