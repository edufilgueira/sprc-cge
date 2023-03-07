require 'rails_helper'

describe Notifier::InternalComment do

  let(:organ) { create(:executive_organ) }
  let(:department) { create(:department, organ: organ) }

  # usuários com notificações habilidatas
  let!(:user) { create(:user, :user) }
  let!(:operator_cge) { create(:user, :operator_cge) }
  let!(:operator_sectoral) { create(:user, :operator_sectoral, organ: organ) }
  let!(:operator_internal) { create(:user, :operator_internal, department: department, organ: department.organ) }
  let!(:operator_subnet) { create(:user, :operator_subnet, organ: organ) }

  let(:child) { create(:ticket, :with_parent, created_by: user, organ: organ, subnet: operator_subnet.subnet) }
  let!(:ticket_department) { create(:ticket_department, ticket: child, department: department) }
  let(:parent) { child.parent }
  let(:comment) { create(:comment, :internal, commentable: child) }
  let(:service) { Notifier::InternalComment.new(comment.id) }

  let(:url_helpers) { Rails.application.routes.url_helpers }
  let(:expected_url_cge) { url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: parent.id) }
  let(:expected_url_operator) { url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id) }


  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Notifier::InternalComment).to receive(:new).with(comment.id, nil) { service }
      allow(service).to receive(:call)
      Notifier::InternalComment.call(comment.id, nil)

      expect(Notifier::InternalComment).to have_received(:new).with(comment.id, nil)
      expect(service).to have_received(:call)
    end
  end

  describe 'initialization' do
    it 'responds to notification' do
      expect(service.comment).to be_an_instance_of(Comment)
    end
  end

  describe 'call' do

    #
    # Quando um operador CGE escreve um comentário interno
    #
    context 'cge' do
      let!(:ticket_log) { create(:ticket_log, ticket: child, resource: comment, responsible: operator_cge) }
      let(:expected_url_operator) { url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id) }
      let(:notification_sectoral) { Mailboxer::Notification.first }
      let(:notification_internal) { Mailboxer::Notification.second }
      let(:notification_subnet) { Mailboxer::Notification.last }

      before { service.call }

      it { expect(Mailboxer::Notification.count).to eq(3) }

      it 'dont send to author' do
        expect(operator_cge.mailbox.notifications).to be_empty
      end

      it 'send to other sectorals' do
        expect(notification_sectoral.subject).to eq(I18n.t('shared.notifications.messages.internal_comment.subject', protocol: child.parent_protocol))
        expect(notification_sectoral.body).to eq(I18n.t('shared.notifications.messages.internal_comment.body.sou', user_name: operator_cge.name, protocol: child.parent_protocol, url: expected_url_operator))
        expect(operator_sectoral.mailbox.notifications.include?(notification_sectoral)).to be_truthy
      end

      it 'send to internals' do
        expect(notification_internal.subject).to eq(I18n.t('shared.notifications.messages.internal_comment.subject', protocol: child.parent_protocol))
        expect(notification_internal.body).to eq(I18n.t('shared.notifications.messages.internal_comment.body.sou', user_name: operator_cge.name, protocol: child.parent_protocol, url: expected_url_operator))
        expect(operator_internal.mailbox.notifications.include?(notification_internal)).to be_truthy
      end

      it 'send to subnets' do
        expect(notification_subnet.subject).to eq(I18n.t('shared.notifications.messages.internal_comment.subject', protocol: child.parent_protocol))
        expect(notification_subnet.body).to eq(I18n.t('shared.notifications.messages.internal_comment.body.sou', user_name: operator_cge.name, protocol: child.parent_protocol, url: expected_url_operator))
        expect(operator_subnet.mailbox.notifications.include?(notification_subnet)).to be_truthy
      end
    end

    #
    # Quando um operador setorial escreve um comentário interno
    #
    context 'sectoral' do
      let!(:other_operator_sectoral) { create(:user, :operator_sectoral, organ: organ) }
      let!(:ticket_log) { create(:ticket_log, ticket: child, resource: comment, responsible: operator_sectoral) }
      let(:notification_cge) { Mailboxer::Notification.first }
      let(:notification_sectoral) { Mailboxer::Notification.second }
      let(:notification_internal) { Mailboxer::Notification.third }
      let(:notification_subnet) { Mailboxer::Notification.last }

      before { service.call }

      it { expect(Mailboxer::Notification.count).to eq(4) }

      it 'send to cges' do
        expect(notification_cge.subject).to eq(I18n.t('shared.notifications.messages.internal_comment.subject', protocol: parent.parent_protocol))
        expect(notification_cge.body).to eq(I18n.t('shared.notifications.messages.internal_comment.body.sou', user_name: operator_sectoral.name, protocol: parent.parent_protocol, url: expected_url_cge))
        expect(operator_cge.mailbox.notifications.include?(notification_cge)).to be_truthy
      end

      it 'send to other sectorals' do
        expect(notification_sectoral.subject).to eq(I18n.t('shared.notifications.messages.internal_comment.subject', protocol: child.parent_protocol))
        expect(notification_sectoral.body).to eq(I18n.t('shared.notifications.messages.internal_comment.body.sou', user_name: operator_sectoral.name, protocol: child.parent_protocol, url: expected_url_operator))
        expect(other_operator_sectoral.mailbox.notifications.include?(notification_sectoral)).to be_truthy
      end

      it 'send to internals' do
        expect(notification_internal.subject).to eq(I18n.t('shared.notifications.messages.internal_comment.subject', protocol: child.parent_protocol))
        expect(notification_internal.body).to eq(I18n.t('shared.notifications.messages.internal_comment.body.sou', user_name: operator_sectoral.name, protocol: child.parent_protocol, url: expected_url_operator))
        expect(operator_internal.mailbox.notifications.include?(notification_internal)).to be_truthy
      end

      it 'send to subnets' do
        expect(notification_subnet.subject).to eq(I18n.t('shared.notifications.messages.internal_comment.subject', protocol: child.parent_protocol))
        expect(notification_subnet.body).to eq(I18n.t('shared.notifications.messages.internal_comment.body.sou', user_name: operator_sectoral.name, protocol: child.parent_protocol, url: expected_url_operator))
        expect(operator_subnet.mailbox.notifications.include?(notification_subnet)).to be_truthy
      end
    end

    #
    # Quando um operador sub-rede escreve um comentário interno
    #
    context 'subrede' do
      let!(:ticket_log) { create(:ticket_log, ticket: child, resource: comment, responsible: operator_subnet) }
      let(:notification_cge) { Mailboxer::Notification.first }
      let(:notification_sectoral) { Mailboxer::Notification.second }
      let(:notification_internal) { Mailboxer::Notification.last }

      before { service.call }

      it { expect(Mailboxer::Notification.count).to eq(3) }

      it 'send to cges' do
        expect(notification_cge.subject).to eq(I18n.t('shared.notifications.messages.internal_comment.subject', protocol: parent.parent_protocol))
        expect(notification_cge.body).to eq(I18n.t('shared.notifications.messages.internal_comment.body.sou', user_name: operator_subnet.name, protocol: parent.parent_protocol, url: expected_url_cge))
        expect(operator_cge.mailbox.notifications.include?(notification_cge)).to be_truthy
      end

      it 'send to sectorals' do
        expect(notification_sectoral.subject).to eq(I18n.t('shared.notifications.messages.internal_comment.subject', protocol: child.parent_protocol))
        expect(notification_sectoral.body).to eq(I18n.t('shared.notifications.messages.internal_comment.body.sou', user_name: operator_subnet.name, protocol: child.parent_protocol, url: expected_url_operator))
        expect(operator_sectoral.mailbox.notifications.include?(notification_sectoral)).to be_truthy
      end

      it 'send to internals' do
        expect(notification_internal.subject).to eq(I18n.t('shared.notifications.messages.internal_comment.subject', protocol: child.parent_protocol))
        expect(notification_internal.body).to eq(I18n.t('shared.notifications.messages.internal_comment.body.sou', user_name: operator_subnet.name, protocol: child.parent_protocol, url: expected_url_operator))
        expect(operator_internal.mailbox.notifications.include?(notification_internal)).to be_truthy
      end
    end

    #
    # Quando um operador interno escreve um comentário interno
    #
    context 'internal' do
      let!(:other_operator_internal) { create(:user, :operator_internal, department: department, organ: department.organ) }
      let!(:ticket_log) { create(:ticket_log, ticket: child, resource: comment, responsible: operator_internal) }
      let(:notification_cge) { Mailboxer::Notification.first }
      let(:notification_sectoral) { Mailboxer::Notification.second }
      let(:notification_internal) { Mailboxer::Notification.third }
      let(:notification_subnet) { Mailboxer::Notification.last }

      before { service.call }

      it { expect(Mailboxer::Notification.count).to eq(4) }

      it 'send to cges' do
        expect(notification_cge.subject).to eq(I18n.t('shared.notifications.messages.internal_comment.subject', protocol: parent.parent_protocol))
        expect(notification_cge.body).to eq(I18n.t('shared.notifications.messages.internal_comment.body.sou', user_name: operator_internal.name, protocol: parent.parent_protocol, url: expected_url_cge))
        expect(operator_cge.mailbox.notifications.include?(notification_cge)).to be_truthy
      end

      it 'send to sectorals' do
        expect(notification_sectoral.subject).to eq(I18n.t('shared.notifications.messages.internal_comment.subject', protocol: child.parent_protocol))
        expect(notification_sectoral.body).to eq(I18n.t('shared.notifications.messages.internal_comment.body.sou', user_name: operator_internal.name, protocol: child.parent_protocol, url: expected_url_operator))
        expect(operator_sectoral.mailbox.notifications.include?(notification_sectoral)).to be_truthy
      end

      it 'send to internals' do
        expect(notification_internal.subject).to eq(I18n.t('shared.notifications.messages.internal_comment.subject', protocol: child.parent_protocol))
        expect(notification_internal.body).to eq(I18n.t('shared.notifications.messages.internal_comment.body.sou', user_name: operator_internal.name, protocol: child.parent_protocol, url: expected_url_operator))
        expect(other_operator_internal.mailbox.notifications.include?(notification_internal)).to be_truthy
      end

      it 'send to subnets' do
        expect(notification_subnet.subject).to eq(I18n.t('shared.notifications.messages.internal_comment.subject', protocol: child.parent_protocol))
        expect(notification_subnet.body).to eq(I18n.t('shared.notifications.messages.internal_comment.body.sou', user_name: operator_internal.name, protocol: child.parent_protocol, url: expected_url_operator))
        expect(operator_subnet.mailbox.notifications.include?(notification_subnet)).to be_truthy
      end
    end

    #
    # Quando um operador escreve um comentário interno e o chamado possui uma sub-unidade
    #
    context 'sub_department internal' do
      let(:sub_department) { create(:sub_department, department: department) }
      let!(:other_operator_internal) { create(:user, :operator_internal, department: department, sub_department: sub_department, organ: department.organ) }
      let!(:ticket_log) { create(:ticket_log, ticket: child, resource: comment, responsible: operator_sectoral) }
      let(:notification_cge) { Mailboxer::Notification.first }
      let(:notification_internal) { Mailboxer::Notification.second }
      let(:notification_subnet) { Mailboxer::Notification.last }

      before do
        create(:ticket_department_sub_department, ticket_department: ticket_department, sub_department: sub_department)
        service.call
      end

      it { expect(Mailboxer::Notification.count).to eq(3) }

      it 'send to cges' do
        expect(notification_cge.subject).to eq(I18n.t('shared.notifications.messages.internal_comment.subject', protocol: parent.parent_protocol))
        expect(notification_cge.body).to eq(I18n.t('shared.notifications.messages.internal_comment.body.sou', user_name: operator_sectoral.name, protocol: parent.parent_protocol, url: expected_url_cge))
        expect(operator_cge.mailbox.notifications.include?(notification_cge)).to be_truthy
      end

      it 'send to internals' do
        expect(notification_internal.subject).to eq(I18n.t('shared.notifications.messages.internal_comment.subject', protocol: child.parent_protocol))
        expect(notification_internal.body).to eq(I18n.t('shared.notifications.messages.internal_comment.body.sou', user_name: operator_sectoral.name, protocol: child.parent_protocol, url: expected_url_operator))
        expect(operator_internal.mailbox.notifications).to be_empty
        expect(other_operator_internal.mailbox.notifications.include?(notification_internal)).to be_truthy
      end

      it 'send to subnets' do
        expect(notification_subnet.subject).to eq(I18n.t('shared.notifications.messages.internal_comment.subject', protocol: child.parent_protocol))
        expect(notification_subnet.body).to eq(I18n.t('shared.notifications.messages.internal_comment.body.sou', user_name: operator_sectoral.name, protocol: child.parent_protocol, url: expected_url_operator))
        expect(operator_subnet.mailbox.notifications.include?(notification_subnet)).to be_truthy
      end
    end
  end
end
