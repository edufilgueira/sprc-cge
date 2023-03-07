require 'rails_helper'

describe Notifier::Referral::AdditionalUserRejected do

  let!(:operator) { create(:user, :operator_sectoral) }
  let(:ticket_department_email) { create(:ticket_department_email) }
  let(:ticket_department) { ticket_department_email.ticket_department }
  let(:ticket) { ticket_department.ticket }
  let(:department) { ticket_department.department }
  let(:justification) { 'Devolvendo a resposta' }

  let(:service) { Notifier::Referral::AdditionalUserRejected.new(ticket.id, ticket_department_email.id, operator.id, justification) }

  let(:url_helpers) { Rails.application.routes.url_helpers }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Notifier::Referral::AdditionalUserRejected).to receive(:new) { service }
      allow(service).to receive(:call)
      Notifier::Referral::AdditionalUserRejected.call(ticket.id, ticket_department_email.id, operator.id, justification)

      expect(Notifier::Referral::AdditionalUserRejected).to have_received(:new).with(ticket.id, ticket_department_email.id, operator.id, justification)
      expect(service).to have_received(:call)
    end
  end

  describe 'initialization' do
    it 'responds to notification' do
      expect(service.ticket).to be_an_instance_of(Ticket)
    end
  end

  describe 'call' do
    let(:notification_operator) { Mailboxer::Notification.last }

    let(:expected_url) { url_helpers.url_for(controller: '/positionings', action: :edit, id: ticket_department_email.token) }

    let(:expected_subject) { I18n.t('shared.notifications.messages.referral.additional_user_rejected.operator.department.subject.sou', protocol: ticket.parent_protocol) }
    let(:expected_body) { I18n.t('shared.notifications.messages.referral.additional_user_rejected.operator.department.body.sou', user_name: operator.name, protocol: ticket.parent_protocol, url: expected_url, justification: justification) }

    before { service.call }

    it { expect(Mailboxer::Notification.count).to eq(1) }
    it { expect(notification_operator.subject).to eq(expected_subject) }
    it { expect(notification_operator.body).to eq(expected_body) }
  end
end
