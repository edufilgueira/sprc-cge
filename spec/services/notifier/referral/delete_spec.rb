require 'rails_helper'

describe Notifier::Referral::Delete do
  let(:organ) { create(:executive_organ) }
  let(:department) { create(:department, organ: organ) }
  let(:sub_department) { create(:sub_department, department: department) }

  let!(:operator_sectoral) { create(:user, :operator_sectoral, organ: organ) }
  let!(:operator_internal) { create(:user, :operator_internal, department: department, organ: department.organ) }
  let!(:operator_subdepartment) { create(:user, :operator_internal, department: department, sub_department: sub_department, organ: department.organ) }

  let(:ticket) { create(:ticket, :with_parent, :in_internal_attendance, classified: true, organ: organ) }

  let(:ticket_department) { create(:ticket_department, department: department, ticket: ticket) }
  let!(:email) { create(:ticket_department_email, ticket_department: ticket_department) }
  let!(:other_email) { create(:ticket_department_email, ticket_department: ticket_department) }

  let(:service) { Notifier::Referral::Delete.new(ticket_department.id, operator_sectoral.id) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Notifier::Referral::Delete).to receive(:new).with(ticket_department.id, operator_sectoral.id) { service }
      allow(service).to receive(:call)
      Notifier::Referral::Delete.call(ticket_department.id, operator_sectoral.id)

      expect(Notifier::Referral::Delete).to have_received(:new).with(ticket_department.id, operator_sectoral.id)
      expect(service).to have_received(:call)
    end
  end

  context 'call' do
    let(:service) { Notifier::Referral::Delete.new(ticket_department.id, operator_sectoral.id) }
    let(:notification_operator) { Mailboxer::Notification.first }

    it 'send notification for department' do

      ticket_department.destroy
      service.call

      expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.referral.delete.subject.sou', protocol: ticket.parent_protocol))
      expect(notification_operator.body).to eq(I18n.t("shared.notifications.messages.referral.delete.body.sou", user_name: operator_sectoral.name, protocol: ticket.parent_protocol))
      expect(operator_internal.mailbox.notifications.include?(notification_operator)).to be_truthy
      expect(Mailboxer::Notification.count).to eq(3)
    end

    it 'send notification for sub_department' do
      create(:ticket_department_sub_department, ticket_department: ticket_department, sub_department: sub_department)

      ticket_department.destroy
      service.call

      expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.referral.delete.subject.sou', protocol: ticket.parent_protocol))
      expect(notification_operator.body).to eq(I18n.t("shared.notifications.messages.referral.delete.body.sou", user_name: operator_sectoral.name, protocol: ticket.parent_protocol))
      expect(operator_subdepartment.mailbox.notifications.include?(notification_operator)).to be_truthy
      expect(Mailboxer::Notification.count).to eq(3)
    end
  end
end
