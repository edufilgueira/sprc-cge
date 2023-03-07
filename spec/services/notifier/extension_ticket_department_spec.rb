require 'rails_helper'

describe Notifier::ExtensionTicketDepartment do

  let(:user) { create(:user, :operator_sectoral) }

  let(:department) { create(:department) }
  let(:sub_department) { create(:sub_department, department: department) }

  let!(:recipient) { create(:user, :operator_internal, department: department, organ: department.organ) }
  let!(:sub_department_operator) { create(:user, :operator_internal, department: department, sub_department: sub_department, organ: department.organ) }

  let(:ticket_child) { create(:ticket, :with_parent) }

  let(:ticket_department) { create(:ticket_department, department: department, ticket: ticket_child) }

  let(:url_helpers) { Rails.application.routes.url_helpers }

  let(:service) { Notifier::ExtensionTicketDepartment.new(ticket_department.id, user.id) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Notifier::ExtensionTicketDepartment).to receive(:new).with(ticket_department.id, user.id) { service }
      allow(service).to receive(:call)
      Notifier::ExtensionTicketDepartment.call(ticket_department.id, user.id)

      expect(Notifier::ExtensionTicketDepartment).to have_received(:new).with(ticket_department.id, user.id)
      expect(service).to have_received(:call)
    end
  end

  describe 'initialization' do
    it 'responds to notification' do
      expect(service.current_user).to be_an_instance_of(User)
      expect(service.ticket_department).to be_an_instance_of(TicketDepartment)
    end
  end

  describe 'call' do
    it 'notify internal operator' do
      expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: ticket_child.id)

      service.call

      notification = Mailboxer::Notification.last

      expect(Mailboxer::Notification.count).to eq(1)
      expect(notification.subject).to eq(I18n.t('shared.notifications.messages.extension_ticket_department.subject', protocol: ticket_child.parent_protocol))
      expect(notification.body).to eq(I18n.t('shared.notifications.messages.extension_ticket_department.body.sou', url: expected_url, deadline_ends_at: ticket_department.deadline_ends_at))
      expect(recipient.mailbox.notifications.include?(notification)).to be_truthy
    end

    it 'notify sub_department internal operator' do
      expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: ticket_child.id)

      create(:ticket_department_sub_department, ticket_department: ticket_department, sub_department: sub_department)

      service.call

      notification = Mailboxer::Notification.last

      expect(Mailboxer::Notification.count).to eq(1)
      expect(notification.subject).to eq(I18n.t('shared.notifications.messages.extension_ticket_department.subject', protocol: ticket_child.parent_protocol))
      expect(notification.body).to eq(I18n.t('shared.notifications.messages.extension_ticket_department.body.sou', url: expected_url, deadline_ends_at: ticket_department.deadline_ends_at))
      expect(recipient.mailbox.notifications).to be_empty
      expect(sub_department_operator.mailbox.notifications.include?(notification)).to be_truthy
    end
  end
end
