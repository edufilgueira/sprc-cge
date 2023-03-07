require 'rails_helper'

describe Notifier::Extension do

  # usuários com notificações habilidatas
  let!(:user) { create(:user, :user) }
  let!(:operator_cge) { create(:user, :operator_cge) }

  let(:organ) { create(:executive_organ) }
  let!(:operator_sectoral) { create(:user, :operator_sectoral, organ: organ) }
  let!(:operator_subnet) { create(:user, :operator_subnet, organ: organ) }

  let(:ticket) { create(:ticket) }
  let(:extension) { create(:extension, ticket: ticket) }

  let(:service) { Notifier::Extension.new(extension.id, nil) }

  let(:url_helpers) { Rails.application.routes.url_helpers }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Notifier::Extension).to receive(:new).with(extension.id, nil) { service }
      allow(service).to receive(:call)
      Notifier::Extension.call(extension.id, nil)

      expect(Notifier::Extension).to have_received(:new).with(extension.id, nil)
      expect(service).to have_received(:call)
    end
  end

  describe 'initialization' do
    it 'responds to notification' do
      expect(service.extension).to be_an_instance_of(Extension)
      expect(service.ticket).to be_an_instance_of(Ticket)
    end
  end

  describe 'call' do

    # IN PROGRESS
    context 'in_progress' do

      context 'sectoral' do
        let(:child) { create(:ticket, :with_parent, organ: organ, subnet: operator_subnet.subnet) }
        let!(:parent) do
          parent = child.parent
          parent.update_attributes(created_by: user)
          parent
        end
        let(:extension) { create(:extension, ticket: child, status: :in_progress) }
        let(:service) { Notifier::Extension.new(extension.id, operator_sectoral.id) }
        let(:notification_user) { Mailboxer::Notification.first }
        let(:notification_chief) { Mailboxer::Notification.last }

        before { service.call }

        it { expect(Mailboxer::Notification.count).to eq(1) }

        it 'send to user' do
          expected_url = url_helpers.url_for(controller: '/platform/tickets', action: 'show', id: parent.id)

          expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.extension.in_progress.platform.subject.sou', protocol: parent.parent_protocol))
          expect(notification_user.body).to eq(I18n.t('shared.notifications.messages.extension.in_progress.platform.body.sou', user_name: operator_sectoral.name, protocol: parent.parent_protocol, url: expected_url))
          expect(user.mailbox.notifications.include?(notification_user)).to be_truthy
        end
      end

      context 'anonymous' do
        let(:child) { create(:ticket, :with_parent, organ: organ, subnet: operator_subnet.subnet) }
        let(:extension) { create(:extension, ticket: child, status: :in_progress) }
        let(:parent) { child.parent }
        let(:service) { Notifier::Extension.new(extension.id, operator_sectoral.id) }
        let(:notification_user) { Mailboxer::Notification.first }
        let(:notification_chief) { Mailboxer::Notification.last }

        before { service.call }

        it { expect(Mailboxer::Notification.count).to eq(1) }

        it 'send to user' do
          expected_url = url_helpers.url_for(controller: '/ticket_area/tickets', action: 'show', id: parent.id)

          expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.extension.in_progress.ticket_area.subject.sou', protocol: parent.parent_protocol))
          expect(notification_user.body).to eq(I18n.t('shared.notifications.messages.extension.in_progress.ticket_area.body.sou', user_name: operator_sectoral.name, protocol: parent.parent_protocol, url: expected_url))
          expect(parent.mailbox.notifications.include?(notification_user)).to be_truthy
        end
      end
    end

    # APPROVED
    context 'approved' do

      let(:child) { create(:ticket, :with_parent, organ: organ, subnet: operator_subnet.subnet) }
      let!(:parent) do
        parent = child.parent
        parent.update_attributes(created_by: user)
        parent
      end
      let(:extension) { create(:extension, ticket: child, status: :approved) }
      let(:service) { Notifier::Extension.new(extension.id, nil) }
      let(:notification_operator) { Mailboxer::Notification.first }
      let(:notification_subnet) { Mailboxer::Notification.second }
      let(:notification_user) { Mailboxer::Notification.last }

      before { service.call }

      it { expect(Mailboxer::Notification.count).to eq(3) }

      it 'send to user' do
        expected_url = url_helpers.url_for(controller: '/platform/tickets', action: 'show', id: parent.id)

        expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.extension.approved.platform.subject.sou', protocol: parent.parent_protocol))
        expect(notification_user.body).to eq(I18n.t('shared.notifications.messages.extension.approved.platform.body.sou', protocol: parent.parent_protocol, url: expected_url))
        expect(user.mailbox.notifications.include?(notification_user)).to be_truthy
      end

      it 'send to sectoral' do
        expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

        expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.extension.approved.operator.subject.sou', protocol: child.parent_protocol))
        expect(notification_operator.body).to eq(I18n.t('shared.notifications.messages.extension.approved.operator.body.sou', protocol: child.parent_protocol, url: expected_url))
        expect(operator_sectoral.mailbox.notifications.include?(notification_operator)).to be_truthy
      end

      it 'send to subnet' do
        expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

        expect(notification_subnet.subject).to eq(I18n.t('shared.notifications.messages.extension.approved.operator.subject.sou', protocol: child.parent_protocol))
        expect(notification_subnet.body).to eq(I18n.t('shared.notifications.messages.extension.approved.operator.body.sou', protocol: child.parent_protocol, url: expected_url))
        expect(operator_subnet.mailbox.notifications.include?(notification_subnet)).to be_truthy
      end

    end

    # REJECTED
    context 'rejected' do
      let(:child) { create(:ticket, :with_parent, organ: organ, subnet: operator_subnet.subnet) }
      let(:extension) { create(:extension, ticket: child, status: :rejected) }
      let(:parent) { child.parent }
      let(:service) { Notifier::Extension.new(extension.id, nil) }
      let(:notification_operator) { Mailboxer::Notification.first }
      let(:notification_subnet) { Mailboxer::Notification.second }
      let(:notification_user) { Mailboxer::Notification.last }

      before { service.call }

      it { expect(Mailboxer::Notification.count).to eq(3) }

      it 'send to user' do
        expected_url = url_helpers.url_for(controller: '/ticket_area/tickets', action: 'show', id: parent.id)

        expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.extension.rejected.ticket_area.subject.sou', protocol: parent.parent_protocol))
        expect(notification_user.body).to eq(I18n.t('shared.notifications.messages.extension.rejected.ticket_area.body.sou', protocol: parent.parent_protocol, url: expected_url))
        expect(parent.mailbox.notifications.include?(notification_user)).to be_truthy
      end

      it 'send to sectoral' do
        expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

        expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.extension.rejected.operator.subject.sou', protocol: child.parent_protocol))
        expect(notification_operator.body).to eq(I18n.t('shared.notifications.messages.extension.rejected.operator.body.sou', protocol: child.parent_protocol, url: expected_url))
        expect(operator_sectoral.mailbox.notifications.include?(notification_operator)).to be_truthy
      end

      it 'send to subnet' do
        expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

        expect(notification_subnet.subject).to eq(I18n.t('shared.notifications.messages.extension.rejected.operator.subject.sou', protocol: child.parent_protocol))
        expect(notification_subnet.body).to eq(I18n.t('shared.notifications.messages.extension.rejected.operator.body.sou', protocol: child.parent_protocol, url: expected_url))
        expect(operator_subnet.mailbox.notifications.include?(notification_subnet)).to be_truthy
      end
    end
  end
end
