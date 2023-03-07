require 'rails_helper'

describe Notifier::TicketDepartment::Poke do
  let(:organ) { create(:executive_organ) }
  let(:department) { create(:department, organ: organ) }
  let(:sub_department) { create(:sub_department, department: department) }

  let!(:operator_sectoral) { create(:user, :operator_sectoral, organ: organ) }
  let!(:operator_internal) { create(:user, :operator_internal, department: department, organ: department.organ) }
  let!(:operator_subdepartment) { create(:user, :operator_internal, department: department, sub_department: sub_department, organ: department.organ) }

  let(:ticket) { create(:ticket, :with_parent, :in_internal_attendance, classified: true, organ: organ) }

  let(:ticket_department) { create(:ticket_department, department: department, ticket: ticket) }
  let!(:email) { create(:ticket_department_email, ticket_department: ticket_department) }

  let(:service) { Notifier::TicketDepartment::Poke.new(ticket_department.id, operator_sectoral.id) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Notifier::TicketDepartment::Poke).to receive(:new).with(ticket_department.id, operator_sectoral.id) { service }
      allow(service).to receive(:call)
      Notifier::TicketDepartment::Poke.call(ticket_department.id, operator_sectoral.id)

      expect(Notifier::TicketDepartment::Poke).to have_received(:new).with(ticket_department.id, operator_sectoral.id)
      expect(service).to have_received(:call)
    end
  end

  context 'call' do
    let(:url_helpers) { Rails.application.routes.url_helpers }
    let(:service) { Notifier::TicketDepartment::Poke.new(ticket_department.id, operator_sectoral.id) }
    let(:notification_operator) { Mailboxer::Notification.first }
    let(:notification_email) { Mailboxer::Notification.last }

    let(:subject) { I18n.t('shared.notifications.messages.ticket_department.poke.subject', protocol: ticket.parent_protocol) }
    let(:body) { I18n.t("shared.notifications.messages.ticket_department.poke.body", protocol: ticket.parent_protocol, deadline: ticket_department.deadline, url: expected_url) }
    let(:expected_url) { url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: ticket.id) }

    it 'send notification for department' do
      ticket_department.destroy
      service.call

      expect(notification_operator.subject).to eq(subject)
      expect(notification_operator.body).to eq(body)
      expect(operator_internal.mailbox.notifications.include?(notification_operator)).to be_truthy
    end

    it 'send notification for ticket_department_email' do
      service.call
      expected_url = url_helpers.url_for(action: :edit, controller: :positionings, id: email.token)
      body =  I18n.t("shared.notifications.messages.ticket_department.poke.body", protocol: ticket.parent_protocol, deadline: ticket_department.deadline, url: expected_url)

      expect(notification_email.subject).to eq(subject)
      expect(notification_email.body).to eq(body)
    end

    it 'send notification for sub_department' do
      create(:ticket_department_sub_department, ticket_department: ticket_department, sub_department: sub_department)

      ticket_department.destroy
      service.call

      expect(notification_operator.subject).to eq(subject)
      expect(notification_operator.body).to eq(body)
      expect(operator_subdepartment.mailbox.notifications.include?(notification_operator)).to be_truthy
    end
  end
end
