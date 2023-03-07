require 'rails_helper'

describe Notifier::Transfer do
  let(:organ) { create(:executive_organ) }

  # usuários com notificações habilidatas
  let!(:user) { create(:user, :user) }
  let!(:operator_cge) { create(:user, :operator_cge) }
  let!(:operator_sectoral) { create(:user, :operator_sectoral, organ: organ) }

  # usuários com notificações desabilidadas
  let!(:operator_sectoral_blocked_notifications) { create(:user, :operator_sectoral, :blocked_notifications, organ: organ) }

  let(:ticket) { create(:ticket) }

  let(:service) { Notifier::Transfer.new(ticket.id, nil, nil) }

  let(:url_helpers) { Rails.application.routes.url_helpers }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Notifier::Transfer).to receive(:new).with(ticket.id, nil, nil) { service }
      allow(service).to receive(:call)
      Notifier::Transfer.call(ticket.id, nil, nil)

      expect(Notifier::Transfer).to have_received(:new).with(ticket.id, nil, nil)
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
      let(:child) { create(:ticket, :with_parent, organ: organ) }
      let(:parent) { child.parent }
      let(:service) { Notifier::Transfer.new(child.id, operator_sectoral.id, nil) }
      let(:notification_operator) { Mailboxer::Notification.first }
      let(:notification_user) { Mailboxer::Notification.last }

      before { service.call }

      it 'send to user' do
        expected_url = url_helpers.url_for(controller: '/ticket_area/tickets', action: 'show', id: parent.id)

        expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.transfer.ticket_area.subject.sou', protocol: parent.parent_protocol))
        expect(notification_user.body).to eq(I18n.t("shared.notifications.messages.transfer.ticket_area.body.sou", organ_name: organ.acronym, protocol: parent.parent_protocol, url: expected_url))
        expect(parent.mailbox.notifications.include?(notification_user)).to be_truthy
      end

      it 'send to operator' do
        expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

        expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.transfer.operator.subject.sou', protocol: child.parent_protocol))
        expect(notification_operator.body).to eq(I18n.t("shared.notifications.messages.transfer.operator.body.sou", user_name: operator_sectoral.name,  organ_name: organ.acronym, protocol: child.parent_protocol, url: expected_url))
        expect(operator_sectoral.mailbox.notifications.include?(notification_operator)).to be_truthy
      end
    end

    # PLATFORM
    context 'platform' do
      let(:child) { create(:ticket, :with_parent, organ: organ) }
      let!(:parent) do
        parent = child.parent
        parent.update_attributes(created_by: user)
        parent
      end
      let(:service) { Notifier::Transfer.new(child.id, operator_sectoral.id, nil) }
      let(:notification_operator) { Mailboxer::Notification.first }
      let(:notification_user) { Mailboxer::Notification.last }

      before { service.call }

      it 'send to user' do
        expected_url = url_helpers.url_for(controller: '/platform/tickets', action: 'show', id: parent.id)

        expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.transfer.platform.subject.sou', protocol: parent.parent_protocol))
        expect(notification_user.body).to eq(I18n.t("shared.notifications.messages.transfer.platform.body.sou", organ_name: organ.acronym, protocol: parent.parent_protocol, url: expected_url))
        expect(user.mailbox.notifications.include?(notification_user)).to be_truthy
      end

      it 'send to operator' do
        expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

        expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.transfer.operator.subject.sou', protocol: child.parent_protocol))
        expect(notification_operator.body).to eq(I18n.t("shared.notifications.messages.transfer.operator.body.sou", user_name: operator_sectoral.name, organ_name: organ.acronym, protocol: child.parent_protocol, url: expected_url))
        expect(operator_sectoral.mailbox.notifications.include?(notification_operator)).to be_truthy
      end

    end

     # OPERATOR SECTORAL
    context 'operator sectoral' do
      let(:child) { create(:ticket, :with_parent, created_by: operator_sectoral, organ: organ) }
      let(:parent) { child.parent }
      let(:service) { Notifier::Transfer.new(child.id, operator_sectoral.id, nil) }
      let(:notification_operator) { Mailboxer::Notification.first }
      let(:notification_user) { Mailboxer::Notification.last }

      before { service.call }

      it 'send to user' do
        expected_url = url_helpers.url_for(controller: '/ticket_area/tickets', action: 'show', id: parent.id)

        expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.transfer.ticket_area.subject.sou', protocol: parent.parent_protocol))
        expect(notification_user.body).to eq(I18n.t("shared.notifications.messages.transfer.ticket_area.body.sou", organ_name: organ.title, protocol: parent.parent_protocol, url: expected_url))
        expect(parent.mailbox.notifications.include?(notification_user)).to be_truthy
      end

      it 'send to operator' do
        expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

        expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.transfer.operator.subject.sou', protocol: child.parent_protocol))
        expect(notification_operator.body).to eq(I18n.t("shared.notifications.messages.transfer.operator.body.sou", user_name: operator_sectoral.name, organ_name: organ.acronym, protocol: child.parent_protocol, url: expected_url))
        expect(operator_sectoral.mailbox.notifications.include?(notification_operator)).to be_truthy
      end

    end

     # OPERATOR INTERNAL
    context 'operator internal' do
      let(:department) { create(:department, organ: organ) }
      let(:operator_internal) { create(:user, :operator_internal, department: department, organ: department.organ) }
      let(:child) { create(:ticket, :with_parent, created_by: operator_internal, organ: organ) }
      let!(:ticket_department) { create(:ticket_department, department: department, ticket: child) }
      let(:parent) { child.parent }
      let(:service) { Notifier::Transfer.new(child.id, operator_internal.id, ticket_department.id) }
      let(:notification_operator) { Mailboxer::Notification.first }
      let(:notification_user) { Mailboxer::Notification.last }

      before { service.call }

      it 'send to user' do

        expected_url = url_helpers.url_for(controller: '/ticket_area/tickets', action: 'show', id: parent.id)

        expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.transfer.ticket_area.subject.sou', protocol: parent.parent_protocol))
        expect(notification_user.body).to eq(I18n.t("shared.notifications.messages.transfer.ticket_area.body.sou", organ_name: department.title, protocol: parent.parent_protocol, url: expected_url))
        expect(parent.mailbox.notifications.include?(notification_user)).to be_truthy
      end

      it 'send to operator' do
        expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

        expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.transfer.operator.subject.sou', protocol: child.parent_protocol))
        expect(notification_operator.body).to eq(I18n.t("shared.notifications.messages.transfer.operator.body.sou", user_name: operator_internal.name, organ_name: organ.acronym, protocol: child.parent_protocol, url: expected_url))
        expect(operator_internal.mailbox.notifications.include?(notification_operator)).to be_truthy
      end

    end

     # OPERATOR INTERNAL WITH SUBDEPARTMENT
    context 'operator internal' do
      let(:department) { create(:department, organ: organ) }
      let(:sub_department) { create(:sub_department, department: department) }
      let(:operator_internal) { create(:user, :operator_internal, department: department, organ: department.organ) }
      let!(:operator_sub_department) { create(:user, :operator_internal, department: department, sub_department: sub_department, organ: department.organ) }
      let(:child) { create(:ticket, :with_parent, created_by: operator_internal, organ: organ) }
      let(:ticket_department) { create(:ticket_department, department: department, ticket: child) }
      let!(:ticket_department_subdepartment) { create(:ticket_department_sub_department, ticket_department: ticket_department, sub_department: sub_department) }
      let(:parent) { child.parent }
      let(:service) { Notifier::Transfer.new(child.id, operator_internal.id, ticket_department.id) }
      let(:notification_operator) { Mailboxer::Notification.first }
      let(:notification_user) { Mailboxer::Notification.last }

      before { service.call }

      it 'send to user' do

        expected_url = url_helpers.url_for(controller: '/ticket_area/tickets', action: 'show', id: parent.id)

        expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.transfer.ticket_area.subject.sou', protocol: parent.parent_protocol))
        expect(notification_user.body).to eq(I18n.t("shared.notifications.messages.transfer.ticket_area.body.sou", organ_name: department.title, protocol: parent.parent_protocol, url: expected_url))
        expect(parent.mailbox.notifications.include?(notification_user)).to be_truthy
      end

      it 'send to operator sub_department' do
        expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

        expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.transfer.operator.subject.sou', protocol: child.parent_protocol))
        expect(notification_operator.body).to eq(I18n.t("shared.notifications.messages.transfer.operator.body.sou", user_name: operator_internal.name, organ_name: organ.acronym, protocol: child.parent_protocol, url: expected_url))
        expect(operator_internal.mailbox.notifications).to be_empty
        expect(operator_sub_department.mailbox.notifications.include?(notification_operator)).to be_truthy
      end

    end

    # OPERATOR SUBREDE
    context 'operator subrede' do
      let(:subnet) { create(:subnet, organ: organ) }
      let(:operator_subnet) { create(:user, :operator_subnet, subnet: subnet) }
      let(:child) { create(:ticket, :with_parent, created_by: operator_subnet, organ: organ, subnet: subnet) }
      let(:parent) { child.parent }
      let(:service) { Notifier::Transfer.new(child.id, operator_subnet.id, nil) }
      let(:notification_operator) { Mailboxer::Notification.first }
      let(:notification_user) { Mailboxer::Notification.last }

      before { service.call }

      it 'send to user' do

        expected_url = url_helpers.url_for(controller: '/ticket_area/tickets', action: 'show', id: parent.id)

        expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.transfer.ticket_area.subject.sou', protocol: parent.parent_protocol))
        expect(notification_user.body).to eq(I18n.t("shared.notifications.messages.transfer.ticket_area.body.sou", organ_name: subnet.title, protocol: parent.parent_protocol, url: expected_url))
        expect(parent.mailbox.notifications.include?(notification_user)).to be_truthy
      end

      it 'send to operator' do
        expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

        expect(Mailboxer::Notification.count).to eq(2)

        expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.transfer.operator.subject.sou', protocol: child.parent_protocol))
        expect(notification_operator.body).to eq(I18n.t("shared.notifications.messages.transfer.operator.body.sou", user_name: operator_subnet.name, organ_name: subnet.title, protocol: child.parent_protocol, url: expected_url))
        expect(operator_subnet.mailbox.notifications.include?(notification_operator)).to be_truthy
      end

      context 'when transfer to organ' do
        let(:operator_sectoral) { create(:user, :operator_sectoral, organ: organ) }
        let(:child) { create(:ticket, :with_parent, created_by: operator_subnet, organ: organ) }

        it 'send to operator' do
          operator_sectoral
          expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

          expect(Mailboxer::Notification.count).to eq(2)

          expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.transfer.operator.subject.sou', protocol: child.parent_protocol))
          expect(notification_operator.body).to eq(I18n.t("shared.notifications.messages.transfer.operator.body.sou", user_name: operator_subnet.name, organ_name: organ.title, protocol: child.parent_protocol, url: expected_url))
          expect(operator_sectoral.mailbox.notifications.include?(notification_operator)).to be_truthy
        end
      end
    end
  end

end
