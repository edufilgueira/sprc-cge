require 'rails_helper'

describe Notifier::Extension::Chief do

  # usuários com notificações habilidatas
  let(:organ) { create(:executive_organ) }
  let(:operator_sectoral) { create(:user, :operator_sectoral, organ: organ) }
  let(:operator_chief) { create(:user, :operator_chief, organ: organ) }

  let(:ticket_parent) { create(:ticket) }
  let(:child) { create(:ticket, :with_parent, organ: organ, parent: ticket_parent) }

  let(:extension) { create(:extension, ticket: child, status: :in_progress) }
  let!(:extension_user) { create(:extension_user, extension: extension, user: operator_chief) }


  let(:service) { Notifier::Extension::Chief.new(extension.id, operator_sectoral.id) }
  let(:url_helpers) { Rails.application.routes.url_helpers }

  before { operator_chief }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Notifier::Extension::Chief).to receive(:new) { service }
      allow(service).to receive(:call)
      Notifier::Extension::Chief.call(extension.id, operator_sectoral.id)

      expect(Notifier::Extension::Chief).to have_received(:new).with(extension.id, operator_sectoral.id)
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
    context 'in_progress' do
      let(:notification_chief) { Mailboxer::Notification.last }

      let(:expected_url) { url_helpers.url_for(controller: '/extensions', action: :edit, id: extension_user.token) }
      let(:expected_subject) { I18n.t('shared.notifications.messages.extension.in_progress.operator.chief.subject.sou', protocol: child.parent_protocol) }
      let(:expected_body) { I18n.t('shared.notifications.messages.extension.in_progress.operator.chief.body.sou', user_name: operator_sectoral.name, protocol: child.parent_protocol, url: expected_url) }

      before { service.call }

      it { expect(Mailboxer::Notification.count).to eq(1) }
      it { expect(notification_chief.subject).to eq(expected_subject) }
      it { expect(notification_chief.body).to eq(expected_body) }
      it { expect(operator_chief.mailbox.notifications.include?(notification_chief)).to be_truthy }
    end
  end
end
