require 'rails_helper'

describe Notifier::Referral::AdditionalUser do

  let(:locale_scope) { 'shared.notifications.messages.referral.operator.department' }
  let!(:operator) { create(:user, :operator_sectoral) }
  let(:ticket_department_email) { create(:ticket_department_email, ticket_department: ticket_department) }
  let(:ticket_department) { create(:ticket_department, considerations: considerations) }
  let(:considerations) { 'Operator considerations' }
  let(:ticket) { ticket_department.ticket }
  let(:department) { ticket_department.department }


  let(:service) { Notifier::Referral::AdditionalUser.new(ticket.id, ticket_department_email.id, operator.id) }

  let(:url_helpers) { Rails.application.routes.url_helpers }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Notifier::Referral::AdditionalUser).to receive(:new) { service }
      allow(service).to receive(:call)
      Notifier::Referral::AdditionalUser.call(ticket.id, ticket_department_email.id, operator.id)

      expect(Notifier::Referral::AdditionalUser).to have_received(:new).with(ticket.id, ticket_department_email.id, operator.id)
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

    let(:expected_considerations) { ticket_department.considerations }
    let(:expected_body_params) do
      {
        scope: locale_scope,
        user_name: operator.name,
        protocol: ticket.parent_protocol,
        url: expected_url,
        considerations: expected_considerations
      }
    end

    let(:expected_url) { url_helpers.url_for(controller: '/positionings', action: :edit, id: ticket_department_email.token) }

    let(:expected_subject) { I18n.t('subject.sou', scope: locale_scope, protocol: ticket.parent_protocol) }
    let(:expected_body) { I18n.t('body.sou', expected_body_params) }

    before { service.call }

    it { expect(Mailboxer::Notification.count).to eq(1) }
    it { expect(notification_operator.subject).to eq(expected_subject) }
    it { expect(notification_operator.body).to eq(expected_body) }

    context 'without considerations' do
      let(:considerations) { '' }
      let(:expected_considerations) { I18n.t('shared.notifications.messages.referral.operator.considerations.empty') }

      it { expect(notification_operator.body).to eq(I18n.t("body.sou", expected_body_params)) }
    end
  end
end
