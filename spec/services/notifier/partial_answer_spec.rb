require 'rails_helper'

describe Notifier::PartialAnswer do

  let(:organ) { create(:executive_organ) }
  let(:department) { create(:department, organ: organ) }
  let(:sub_department) { create(:sub_department, department: department) }

  # usuários com notificações habilidatas
  let!(:operator_sectoral) { create(:user, :operator_sectoral, organ: organ) }
  let!(:operator_internal) { create(:user, :operator_internal, department: department, organ: department.organ) }
  let!(:operator_subdepartment) { create(:user, :operator_internal, department: department, sub_department: sub_department, organ: department.organ) }

  let!(:ticket) { create(:ticket, :with_parent, organ: organ, internal_status: :partial_answer) }

  let(:service) { Notifier::PartialAnswer.new(organ.id) }

  let(:url_helpers) { Rails.application.routes.url_helpers }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Notifier::PartialAnswer).to receive(:new).with(organ.id) { service }
      allow(service).to receive(:call)
      Notifier::PartialAnswer.call(organ.id)

      expect(Notifier::PartialAnswer).to have_received(:new).with(organ.id)
      expect(service).to have_received(:call)
    end
  end

  describe 'initialization' do
    it 'responds to notification' do
      expect(service.organ).to eq(organ)
    end
  end

  describe 'call' do
    let(:expected_url) { ERB::Util.html_escape(url_helpers.operator_tickets_url(ticket_type: :sou, internal_status: :partial_answer)) }

    let!(:ticket_department) do
      create(:ticket_department, ticket: ticket, department: department)
    end

    it 'send to sectoral sou' do
      service.call
      notification = operator_sectoral.mailbox.notifications.last

      expect(notification.subject).to eq(I18n.t('shared.notifications.messages.partial_answer.subject'))
      expect(notification.body).to eq(I18n.t('shared.notifications.messages.partial_answer.body', url: expected_url))
    end

    it 'send to internal sou' do
      service.call
      notification = operator_internal.mailbox.notifications.last

      expect(notification.subject).to eq(I18n.t('shared.notifications.messages.partial_answer.subject'))
      expect(notification.body).to eq(I18n.t('shared.notifications.messages.partial_answer.body', url: expected_url))
    end

    it 'send to internal sub_department' do
      create(:ticket_department_sub_department, sub_department: sub_department, ticket_department: ticket_department)
      service.call
      notification = operator_subdepartment.mailbox.notifications.last
      expect(operator_internal.mailbox.notifications).to be_empty
      expect(notification.subject).to eq(I18n.t('shared.notifications.messages.partial_answer.subject'))
      expect(notification.body).to eq(I18n.t('shared.notifications.messages.partial_answer.body', url: expected_url))
    end
  end
end
