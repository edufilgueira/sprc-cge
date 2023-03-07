require 'rails_helper'

describe Notifier::UserComment do

  let(:organ) { create(:executive_organ) }
  let(:department) { create(:department, organ: organ) }

  # usuários com notificações habilidatas
  let!(:user) { create(:user, :user) }
  let!(:operator_cge) { create(:user, :operator_cge) }
  let!(:operator_sectoral) { create(:user, :operator_sectoral, organ: organ) }
  let!(:operator_subnet) { create(:user, :operator_subnet, organ: organ) }

  let(:child) { create(:ticket, :with_parent, organ: organ, subnet: operator_subnet.subnet) }
  let(:parent) do
    ticket = child.parent
    ticket.update_column(:created_by_id, user.id)
    ticket
  end
  let(:comment) { create(:comment, :external, commentable: child) }
  let(:service) { Notifier::UserComment.new(comment.id) }

  let(:url_helpers) { Rails.application.routes.url_helpers }
  let(:expected_url_ticket) { url_helpers.url_for(controller: '/ticket_area/tickets', action: 'show', id: parent.id) }
  let(:expected_url_user) { url_helpers.url_for(controller: '/platform/tickets', action: 'show', id: parent.id) }
  let(:expected_url_cge) { url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: parent.id) }
  let(:expected_url_operator) { url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id) }


  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Notifier::UserComment).to receive(:new).with(comment.id, nil) { service }
      allow(service).to receive(:call)
      Notifier::UserComment.call(comment.id, nil)

      expect(Notifier::UserComment).to have_received(:new).with(comment.id, nil)
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
    # Quando um usuário logado escreve um comentário
    #
    context 'user' do
      let(:comment) { create(:comment, :external, commentable: parent) }
      let!(:ticket_log) { create(:ticket_log, ticket: parent, resource: comment, responsible: user) }
      let(:service) { Notifier::UserComment.new(comment.id) }
      let(:notification_cge) { Mailboxer::Notification.first }
      let(:notification_sectoral) { Mailboxer::Notification.second }
      let(:notification_subnet) { Mailboxer::Notification.last }

      before { service.call }

      it { expect(Mailboxer::Notification.count).to eq(3) }

      it 'dont send to author' do
        expect(user.mailbox.notifications).to be_empty
      end

      it 'send to cge' do
        expect(notification_cge.subject).to eq(I18n.t('shared.notifications.messages.user_comment.operator.subject.sou', protocol: parent.parent_protocol))
        expect(notification_cge.body).to eq(I18n.t('shared.notifications.messages.user_comment.operator.body.sou', user_name: user.as_author, protocol: parent.parent_protocol, url: expected_url_cge))
        expect(operator_cge.mailbox.notifications.include?(notification_cge)).to be_truthy
      end

      it 'send to sectorals' do
        expect(notification_sectoral.subject).to eq(I18n.t('shared.notifications.messages.user_comment.operator.subject.sou', protocol: child.parent_protocol))
        expect(notification_sectoral.body).to eq(I18n.t('shared.notifications.messages.user_comment.operator.body.sou', user_name: user.as_author, protocol: child.parent_protocol, url: expected_url_operator))
        expect(operator_sectoral.mailbox.notifications.include?(notification_sectoral)).to be_truthy
      end

      it 'send to subnet' do
        expect(notification_subnet.subject).to eq(I18n.t('shared.notifications.messages.user_comment.operator.subject.sou', protocol: child.parent_protocol))
        expect(notification_subnet.body).to eq(I18n.t('shared.notifications.messages.user_comment.operator.body.sou', user_name: user.as_author, protocol: child.parent_protocol, url: expected_url_operator))
        expect(operator_subnet.mailbox.notifications.include?(notification_subnet)).to be_truthy
      end
    end

    #
    # Quando um usuário não logado escreve um comentário
    #
    context 'ticket user' do
      let(:child) { create(:ticket, :anonymous, :with_parent, organ: organ, subnet: operator_subnet.subnet) }
      let(:parent) { child.parent }
      let(:comment) { create(:comment, :external, commentable: parent) }
      let!(:ticket_log) { create(:ticket_log, ticket: parent, resource: comment, responsible: parent) }
      let(:service) { Notifier::UserComment.new(comment.id) }
      let(:notification_cge) { Mailboxer::Notification.first }
      let(:notification_sectoral) { Mailboxer::Notification.second }
      let(:notification_subnet) { Mailboxer::Notification.last }

      before { service.call }

      it { expect(Mailboxer::Notification.count).to eq(3) }

      it 'send to cge' do
        expect(notification_cge.subject).to eq(I18n.t('shared.notifications.messages.user_comment.operator.subject.sou', protocol: parent.parent_protocol))
        expect(notification_cge.body).to eq(I18n.t('shared.notifications.messages.user_comment.operator.body.sou', user_name: parent.as_author, protocol: parent.parent_protocol, url: expected_url_cge))
        expect(operator_cge.mailbox.notifications.include?(notification_cge)).to be_truthy
      end

      it 'send to sectorals' do
        expect(notification_sectoral.subject).to eq(I18n.t('shared.notifications.messages.user_comment.operator.subject.sou', protocol: child.parent_protocol))
        expect(notification_sectoral.body).to eq(I18n.t('shared.notifications.messages.user_comment.operator.body.sou', user_name: parent.as_author, protocol: child.parent_protocol, url: expected_url_operator))
        expect(operator_sectoral.mailbox.notifications.include?(notification_sectoral)).to be_truthy
      end

      it 'send to subnet' do
        expect(notification_subnet.subject).to eq(I18n.t('shared.notifications.messages.user_comment.operator.subject.sou', protocol: child.parent_protocol))
        expect(notification_subnet.body).to eq(I18n.t('shared.notifications.messages.user_comment.operator.body.sou', user_name: parent.as_author, protocol: child.parent_protocol, url: expected_url_operator))
        expect(operator_subnet.mailbox.notifications.include?(notification_subnet)).to be_truthy
      end
    end

    #
    # Quando um operador CGE escreve um comentário
    #
    context 'cge' do
      let(:child) { create(:ticket, :anonymous, :with_parent, organ: organ, subnet: operator_subnet.subnet) }
      let(:parent) { child.parent }
      let(:comment) { create(:comment, :external, commentable: parent) }
      let!(:ticket_log) { create(:ticket_log, ticket: parent, resource: comment, responsible: operator_cge) }

      let(:service) { Notifier::UserComment.new(comment.id) }
      let(:notification_user) { Mailboxer::Notification.first }
      let(:notification_sectoral) { Mailboxer::Notification.second }
      let(:notification_subnet) { Mailboxer::Notification.last }


      before { service.call }

      it { expect(Mailboxer::Notification.count).to eq(3) }

      it 'send to ticket user' do
        expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.user_comment.ticket_area.subject.sou', protocol: parent.parent_protocol))
        expect(notification_user.body).to eq(I18n.t('shared.notifications.messages.user_comment.ticket_area.body.sou', user_name: operator_cge.as_author, protocol: parent.parent_protocol, url: expected_url_ticket))
        expect(parent.mailbox.notifications.include?(notification_user)).to be_truthy
      end

      it 'send to sectoral' do
        expect(notification_sectoral.subject).to eq(I18n.t('shared.notifications.messages.user_comment.operator.subject.sou', protocol: child.parent_protocol))
        expect(notification_sectoral.body).to eq(I18n.t('shared.notifications.messages.user_comment.operator.body.sou', user_name: operator_cge.as_author, protocol: child.parent_protocol, url: expected_url_operator))
        expect(operator_sectoral.mailbox.notifications.include?(notification_sectoral)).to be_truthy
      end

      it 'send to subnet' do
        expect(notification_subnet.subject).to eq(I18n.t('shared.notifications.messages.user_comment.operator.subject.sou', protocol: child.parent_protocol))
        expect(notification_subnet.body).to eq(I18n.t('shared.notifications.messages.user_comment.operator.body.sou', user_name: operator_cge.as_author, protocol: child.parent_protocol, url: expected_url_operator))
        expect(operator_subnet.mailbox.notifications.include?(notification_subnet)).to be_truthy
      end
    end

    #
    # Quando um operador setorial escreve um comentário
    #
    context 'sectoral' do
      let!(:another_operator_sectoral) { create(:user, :operator_sectoral, organ: organ) }
      let(:comment) { create(:comment, :external, commentable: parent) }
      let!(:ticket_log) { create(:ticket_log, ticket: parent, resource: comment, responsible: operator_sectoral) }
      let(:notification_user) { Mailboxer::Notification.first }
      let(:notification_cge) { Mailboxer::Notification.second }
      let(:notification_sectoral) { Mailboxer::Notification.third }
      let(:notification_subnet) { Mailboxer::Notification.last }

      before { service.call }

      it { expect(Mailboxer::Notification.count).to eq(4) }

      it 'send to user' do
        expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.user_comment.platform.subject.sou', protocol: parent.parent_protocol))
        expect(notification_user.body).to eq(I18n.t('shared.notifications.messages.user_comment.platform.body.sou', user_name: operator_sectoral.as_author, protocol: parent.parent_protocol, url: expected_url_user))
        expect(user.mailbox.notifications.include?(notification_user)).to be_truthy
      end

      it 'send to cge' do
        expect(notification_cge.subject).to eq(I18n.t('shared.notifications.messages.user_comment.operator.subject.sou', protocol: parent.parent_protocol))
        expect(notification_cge.body).to eq(I18n.t('shared.notifications.messages.user_comment.operator.body.sou', user_name: operator_sectoral.as_author, protocol: parent.parent_protocol, url: expected_url_cge))
        expect(operator_cge.mailbox.notifications.include?(notification_cge)).to be_truthy
      end

      it 'send to another sectoral' do
        expect(notification_sectoral.subject).to eq(I18n.t('shared.notifications.messages.user_comment.operator.subject.sou', protocol: child.parent_protocol))
        expect(notification_sectoral.body).to eq(I18n.t('shared.notifications.messages.user_comment.operator.body.sou', user_name: operator_sectoral.as_author, protocol: child.parent_protocol, url: expected_url_operator))
        expect(another_operator_sectoral.mailbox.notifications.include?(notification_sectoral)).to be_truthy
      end

      it 'send to subnet' do
        expect(notification_subnet.subject).to eq(I18n.t('shared.notifications.messages.user_comment.operator.subject.sou', protocol: child.parent_protocol))
        expect(notification_subnet.body).to eq(I18n.t('shared.notifications.messages.user_comment.operator.body.sou', user_name: operator_sectoral.as_author, protocol: child.parent_protocol, url: expected_url_operator))
        expect(operator_subnet.mailbox.notifications.include?(notification_subnet)).to be_truthy
      end
    end
  end
end
