require 'rails_helper'

describe Notifier::Reopen do
  # usuários com notificações habilidatas

  let!(:user) { create(:user, :user) }
  let!(:operator_cge) { create(:user, :operator_cge) }

  let(:organ) { create(:executive_organ) }
  let!(:operator_sectoral) { create(:user, :operator_sectoral, organ: organ) }
  let!(:operator_sectoral_sic) { create(:user, :operator_sectoral_sic, organ: organ) }
  let!(:operator_subnet) { create(:user, :operator_subnet, organ: organ) }

  let(:ticket) { create(:ticket) }

  let(:service) { Notifier::Reopen.new(ticket.id) }

  let(:url_helpers) { Rails.application.routes.url_helpers }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Notifier::Reopen).to receive(:new).with(ticket.id) { service }
      allow(service).to receive(:call)
      Notifier::Reopen.call(ticket.id)

      expect(Notifier::Reopen).to have_received(:new).with(ticket.id)
      expect(service).to have_received(:call)
    end
  end

  describe 'initialization' do
    it 'responds to notification' do
      expect(service.ticket).to be_an_instance_of(Ticket)
    end
  end

  describe 'call' do

    # child
    context 'child' do
      let(:child) { create(:ticket, :with_parent, organ: organ, subnet: operator_subnet.subnet) }
      let(:parent) { child.parent }
      let(:service) { Notifier::Reopen.new(child.id) }
      let(:notification_cge) { Mailboxer::Notification.first }
      let(:notification_sectoral) { Mailboxer::Notification.second }
      let(:notification_sectoral_sic) { Mailboxer::Notification.second }
      let(:notification_subnet) { Mailboxer::Notification.last }

      before { service.call }

      context 'sou' do

        it { expect(Mailboxer::Notification.count).to eq(3) }

        it 'send to cge' do
          expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: parent.id)

          expect(notification_cge.subject).to eq(I18n.t('shared.notifications.messages.reopen.operator.subject.sou', protocol: parent.parent_protocol))
          expect(notification_cge.body).to eq(I18n.t('shared.notifications.messages.reopen.operator.body.sou', protocol: parent.parent_protocol, url: expected_url))
          expect(operator_cge.mailbox.notifications.include?(notification_cge)).to be_truthy
        end

        it 'send to sectoral' do
          expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

          expect(notification_sectoral.subject).to eq(I18n.t('shared.notifications.messages.reopen.operator.subject.sou', protocol: child.parent_protocol))
          expect(notification_sectoral.body).to eq(I18n.t('shared.notifications.messages.reopen.operator.body.sou', protocol: child.parent_protocol, url: expected_url))
          expect(operator_sectoral.mailbox.notifications.include?(notification_sectoral)).to be_truthy
        end

        it 'send to subnet' do
          expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

          expect(notification_subnet.subject).to eq(I18n.t('shared.notifications.messages.reopen.operator.subject.sou', protocol: child.parent_protocol))
          expect(notification_subnet.body).to eq(I18n.t('shared.notifications.messages.reopen.operator.body.sou', protocol: child.parent_protocol, url: expected_url))
          expect(operator_subnet.mailbox.notifications.include?(notification_subnet)).to be_truthy
        end
      end

      context 'sic' do
        let(:child) { create(:ticket, :sic, :with_parent_sic, organ: organ, subnet: operator_subnet.subnet) }

        it { expect(Mailboxer::Notification.count).to eq(3) }

        it 'send to cge' do
          expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: parent.id)

          expect(notification_cge.subject).to eq(I18n.t('shared.notifications.messages.reopen.operator.subject.sic', protocol: parent.parent_protocol))
          expect(notification_cge.body).to eq(I18n.t('shared.notifications.messages.reopen.operator.body.sic', protocol: parent.parent_protocol, url: expected_url))
          expect(operator_cge.mailbox.notifications.include?(notification_cge)).to be_truthy
        end

        it 'send to sectoral' do
          expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

          expect(notification_sectoral.subject).to eq(I18n.t('shared.notifications.messages.reopen.operator.subject.sic', protocol: child.parent_protocol))
          expect(notification_sectoral.body).to eq(I18n.t('shared.notifications.messages.reopen.operator.body.sic', protocol: child.parent_protocol, url: expected_url))
          expect(operator_sectoral_sic.mailbox.notifications.include?(notification_sectoral)).to be_truthy
        end

        it 'send to subnet' do
          expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

          expect(notification_subnet.subject).to eq(I18n.t('shared.notifications.messages.reopen.operator.subject.sic', protocol: child.parent_protocol))
          expect(notification_subnet.body).to eq(I18n.t('shared.notifications.messages.reopen.operator.body.sic', protocol: child.parent_protocol, url: expected_url))
          expect(operator_subnet.mailbox.notifications.include?(notification_subnet)).to be_truthy
        end
      end


    end

    # parent
    context 'parent' do
      let(:parent) { create(:ticket) }
      let(:service) { Notifier::Reopen.new(parent.id) }
      let(:notification_cge) { Mailboxer::Notification.first }

      before { service.call }

      it { expect(Mailboxer::Notification.count).to eq(1) }

      it 'send to cge' do
        expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: parent.id)

        expect(notification_cge.subject).to eq(I18n.t('shared.notifications.messages.reopen.operator.subject.sou', protocol: parent.parent_protocol))
        expect(notification_cge.body).to eq(I18n.t('shared.notifications.messages.reopen.operator.body.sou', protocol: parent.parent_protocol, url: expected_url))
        expect(operator_cge.mailbox.notifications.include?(notification_cge)).to be_truthy
      end
    end
  end
end
