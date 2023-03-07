require 'rails_helper'

describe Notifier::Share do
  let(:organ) { create(:executive_organ) }

  # usuários com notificações habilidatas
  let!(:user) { create(:user, :user) }
  let!(:operator_cge) { create(:user, :operator_cge) }
  let!(:operator_sectoral) { create(:user, :operator_sectoral, organ: organ) }
  let!(:operator_subnet) { create(:user, :operator_subnet, organ: organ) }
  let(:subnet) { operator_subnet.subnet }

  # usuários com notificações desabilidadas
  let!(:operator_sectoral_blocked_notifications) { create(:user, :operator_sectoral, :blocked_notifications, organ: organ) }

  let(:ticket) { create(:ticket) }

  let(:service) { Notifier::Share.new(ticket.id, user.id) }

  let(:url_helpers) { Rails.application.routes.url_helpers }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Notifier::Share).to receive(:new).with(ticket.id, user.id) { service }
      allow(service).to receive(:call)
      Notifier::Share.call(ticket.id, user.id)

      expect(Notifier::Share).to have_received(:new).with(ticket.id, user.id)
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
      let(:child) { create(:ticket, :with_parent, organ: organ, subnet: subnet) }
      let(:parent) { child.parent }
      let(:service) { Notifier::Share.new(child.id, operator_sectoral.id) }
      let(:notification_operator) { Mailboxer::Notification.first }
      let(:notification_subnet) { Mailboxer::Notification.second }
      let(:notification_user) { Mailboxer::Notification.last }

      before { service.call }

      it 'send to user' do
        expected_url = url_helpers.url_for(controller: '/ticket_area/tickets', action: 'show', id: parent.id)

        expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.share.ticket_area.subject.sou', protocol: parent.parent_protocol))
        expect(notification_user.body).to eq(I18n.t("shared.notifications.messages.share.ticket_area.body.sou", organ_name: organ.title, protocol: parent.parent_protocol, url: expected_url))
        expect(parent.mailbox.notifications.include?(notification_user)).to be_truthy
      end

      it 'send to operator' do
        expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

        expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.share.operator.subject.sou', protocol: child.parent_protocol))
        expect(notification_operator.body).to eq(I18n.t("shared.notifications.messages.share.operator.body.sou", user_name: operator_sectoral.name, organ_name: organ.title, protocol: child.parent_protocol, url: expected_url))
        expect(operator_sectoral.mailbox.notifications.include?(notification_operator)).to be_truthy
      end

      it 'send to subnet' do
        expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

        expect(notification_subnet.subject).to eq(I18n.t('shared.notifications.messages.share.operator.subject.sou', protocol: child.parent_protocol))
        expect(notification_subnet.body).to eq(I18n.t("shared.notifications.messages.share.operator.body.sou", user_name: operator_sectoral.name, organ_name: organ.title, protocol: child.parent_protocol, url: expected_url))
        expect(operator_subnet.mailbox.notifications.include?(notification_subnet)).to be_truthy
      end

    end

    # PLATFORM
    context 'platform' do
      let(:child) { create(:ticket, :with_parent, organ: organ, subnet: subnet) }
      let!(:parent) do
        parent = child.parent
        parent.update_attributes(created_by: user)
        parent
      end
      let(:service) { Notifier::Share.new(child.id, operator_sectoral.id) }
      let(:notification_operator) { Mailboxer::Notification.first }
      let(:notification_subnet) { Mailboxer::Notification.second }
      let(:notification_user) { Mailboxer::Notification.last }

      before { service.call }

      it 'send to user' do
        expected_url = url_helpers.url_for(controller: '/platform/tickets', action: 'show', id: parent.id)

        expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.share.platform.subject.sou', protocol: parent.parent_protocol))
        expect(notification_user.body).to eq(I18n.t("shared.notifications.messages.share.platform.body.sou", organ_name: organ.title, protocol: parent.parent_protocol, url: expected_url))
        expect(user.mailbox.notifications.include?(notification_user)).to be_truthy
      end

      it 'send to operator' do
        expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

        expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.share.operator.subject.sou', protocol: child.parent_protocol))
        expect(notification_operator.body).to eq(I18n.t("shared.notifications.messages.share.operator.body.sou", user_name: operator_sectoral.name, organ_name: organ.title, protocol: child.parent_protocol, url: expected_url))
        expect(operator_sectoral.mailbox.notifications.include?(notification_operator)).to be_truthy
      end

      it 'send to subnet' do
        expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

        expect(notification_subnet.subject).to eq(I18n.t('shared.notifications.messages.share.operator.subject.sou', protocol: child.parent_protocol))
        expect(notification_subnet.body).to eq(I18n.t("shared.notifications.messages.share.operator.body.sou", user_name: operator_sectoral.name, organ_name: organ.title, protocol: child.parent_protocol, url: expected_url))
        expect(operator_subnet.mailbox.notifications.include?(notification_subnet)).to be_truthy
      end

    end

    # OPERATOR CGE
    context 'operator cge' do
      let(:child) { create(:ticket, :with_parent, organ: organ, subnet: subnet) }
      let!(:parent) do
        parent = child.parent
        parent.update_attributes(created_by: user)
        parent
      end
      let(:service) { Notifier::Share.new(child.id, operator_cge.id) }
      let(:notification_operator) { Mailboxer::Notification.first }
      let(:notification_subnet) { Mailboxer::Notification.second }
      let(:notification_user) { Mailboxer::Notification.last }

      before { service.call }

      it 'send to user' do
        expected_url = url_helpers.url_for(controller: '/platform/tickets', action: 'show', id: parent.id)

        expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.share.platform.subject.sou', protocol: parent.parent_protocol))
        expect(notification_user.body).to eq(I18n.t("shared.notifications.messages.share.platform.body.sou", organ_name: organ.title, protocol: parent.parent_protocol, url: expected_url))
        expect(user.mailbox.notifications.include?(notification_user)).to be_truthy
      end

      it 'send to operator' do
        expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

        expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.share.operator.subject.sou', protocol: child.parent_protocol))
        expect(notification_operator.body).to eq(I18n.t("shared.notifications.messages.share.operator.body.sou", user_name: operator_cge.name, organ_name: organ.title, protocol: child.parent_protocol, url: expected_url))
        expect(operator_sectoral.mailbox.notifications.include?(notification_operator)).to be_truthy
      end

      it 'send to subnet' do
        expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

        expect(notification_subnet.subject).to eq(I18n.t('shared.notifications.messages.share.operator.subject.sou', protocol: child.parent_protocol))
        expect(notification_subnet.body).to eq(I18n.t("shared.notifications.messages.share.operator.body.sou", user_name: operator_cge.name, organ_name: organ.title, protocol: child.parent_protocol, url: expected_url))
        expect(operator_subnet.mailbox.notifications.include?(notification_subnet)).to be_truthy
      end

    end

    # OPERATOR SECTORAL
    context 'operator sectoral' do
      let(:child) { create(:ticket, :with_parent, created_by: operator_sectoral, organ: organ, subnet: subnet) }
      let(:parent) { child.parent }
      let(:service) { Notifier::Share.new(child.id, operator_sectoral.id) }
      let(:notification_operator) { Mailboxer::Notification.first }
      let(:notification_subnet) { Mailboxer::Notification.second }
      let(:notification_user) { Mailboxer::Notification.last }

      before { service.call }

      it 'send to user' do
        expected_url = url_helpers.url_for(controller: '/ticket_area/tickets', action: 'show', id: parent.id)

        expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.share.ticket_area.subject.sou', protocol: parent.parent_protocol))
        expect(notification_user.body).to eq(I18n.t("shared.notifications.messages.share.ticket_area.body.sou", organ_name: organ.title, protocol: parent.parent_protocol, url: expected_url))
        expect(parent.mailbox.notifications.include?(notification_user)).to be_truthy
      end

      it 'send to operator' do
        expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

        expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.share.operator.subject.sou', protocol: child.parent_protocol))
        expect(notification_operator.body).to eq(I18n.t("shared.notifications.messages.share.operator.body.sou", user_name: operator_sectoral.name, organ_name: organ.title, protocol: child.parent_protocol, url: expected_url))
        expect(operator_sectoral.mailbox.notifications.include?(notification_operator)).to be_truthy
      end

      it 'send to subnet' do
        expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

        expect(notification_subnet.subject).to eq(I18n.t('shared.notifications.messages.share.operator.subject.sou', protocol: child.parent_protocol))
        expect(notification_subnet.body).to eq(I18n.t("shared.notifications.messages.share.operator.body.sou", user_name: operator_sectoral.name, organ_name: organ.title, protocol: child.parent_protocol, url: expected_url))
        expect(operator_subnet.mailbox.notifications.include?(notification_subnet)).to be_truthy
      end

    end

  end
end
