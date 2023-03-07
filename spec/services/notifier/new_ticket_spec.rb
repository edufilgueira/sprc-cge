require 'rails_helper'

describe Notifier::NewTicket do

  let(:organ) { create(:executive_organ) }

  # usuários com notificações habilidatas
  let!(:user) { create(:user, :user) }
  let!(:operator_cge) { create(:user, :operator_cge) }
  let(:operator_sectoral) { create(:user, :operator_sectoral, organ: organ) }
  let(:operator_subnet) { create(:user, :operator_subnet, organ: organ) }

  # usuários com notificações desabilidadas
  let!(:operator_sectoral_blocked_notifications) { create(:user, :operator_sectoral, :blocked_notifications, organ: organ) }

  let(:ticket) { create(:ticket) }

  let(:service) { Notifier::NewTicket.new(ticket.id) }

  let(:url_helpers) { Rails.application.routes.url_helpers }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Notifier::NewTicket).to receive(:new).with(ticket.id) { service }
      allow(service).to receive(:call)
      Notifier::NewTicket.call(ticket.id)

      expect(Notifier::NewTicket).to have_received(:new).with(ticket.id)
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

      context 'anonymous' do

        let(:child) { create(:ticket, :with_parent, :anonymous, organ: organ) }
        let(:parent) do
          parent = child.parent
          parent.anonymous = true
          parent.save
          parent
        end
        let(:service) { Notifier::NewTicket.new(parent.id) }
        let(:notification_operator) { Mailboxer::Notification.first }
        let(:notification_user) { Mailboxer::Notification.last }

        before { operator_sectoral && service.call }

        it 'send to user' do
          expected_url = url_helpers.url_for(controller: '/ticket_area/tickets', action: 'show', id: parent.id)

          expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.new_ticket.ticket_area.subject.sou', protocol: parent.parent_protocol))
          expect(notification_user.body).to eq(I18n.t("shared.notifications.messages.new_ticket.ticket_area.body.sou.anonymous", protocol: parent.parent_protocol, url: expected_url, password: parent.plain_password))
          expect(parent.mailbox.notifications.include?(notification_user)).to be_truthy
        end

        it 'send to operator' do
          expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

          expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.new_ticket.operator.subject.sou', protocol: child.parent_protocol))
          expect(notification_operator.body).to eq(I18n.t('shared.notifications.messages.new_ticket.operator.body.sou.anonymous', protocol: child.parent_protocol, url: expected_url))
          expect(operator_sectoral.mailbox.notifications.include?(notification_operator)).to be_truthy
        end

        it 'dont send to operator blocked' do
          expect(operator_sectoral_blocked_notifications.mailbox.notifications.include?(notification_operator)).to be_falsey
        end

        it 'dont send to cge' do
          expect(operator_cge.mailbox.notifications).to be_empty
        end
      end

      context 'identified' do

        let(:email) { 'user_identified@example.com' }
        let(:child) { create(:ticket, :with_parent, email: email, organ: organ, subnet: operator_subnet.subnet) }
        let(:parent) { child.parent }

        let(:service) { Notifier::NewTicket.new(parent.id) }
        let(:notification_operator) { Mailboxer::Notification.first }
        let(:notification_subnet) { Mailboxer::Notification.second }
        let(:notification_user) { Mailboxer::Notification.last }

        before { operator_sectoral && service.call }

        it 'send to user' do
          expected_url = url_helpers.url_for(controller: '/ticket_area/tickets', action: 'show', id: parent.id)

          expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.new_ticket.ticket_area.subject.sou', protocol: parent.parent_protocol))
          expect(notification_user.body).to eq(I18n.t('shared.notifications.messages.new_ticket.ticket_area.body.sou.identified', protocol: parent.parent_protocol, url: expected_url, password: parent.plain_password))
          expect(parent.mailbox.notifications.include?(notification_user)).to be_truthy
        end

        it 'send to operator' do
          expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

          expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.new_ticket.operator.subject.sou', protocol: child.parent_protocol))
          expect(notification_operator.body).to eq(I18n.t('shared.notifications.messages.new_ticket.operator.body.sou.identified', name: child.name, protocol: child.parent_protocol, url: expected_url))
          expect(operator_sectoral.mailbox.notifications.include?(notification_operator)).to be_truthy
        end

        it 'send to subnet' do
          expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

          expect(notification_subnet.subject).to eq(I18n.t('shared.notifications.messages.new_ticket.operator.subject.sou', protocol: child.parent_protocol))
          expect(notification_subnet.body).to eq(I18n.t('shared.notifications.messages.new_ticket.operator.body.sou.identified', name: child.name, protocol: child.parent_protocol, url: expected_url))
          expect(operator_subnet.mailbox.notifications.include?(notification_subnet)).to be_truthy
        end

        it 'dont send to cge' do
          expect(operator_cge.mailbox.notifications).to be_empty
        end
      end

      context 'denunciation' do
        let!(:denunciation_cge) { create(:user, :operator_cge, denunciation_tracking: true) }

        let(:ticket)  { create(:ticket, :anonymous, :denunciation) }
        let(:child) { create(:ticket, :anonymous, :denunciation, organ: organ, parent: ticket) }
        let(:parent) { child.parent }

        let(:service) { Notifier::NewTicket.new(parent.id) }
        let(:notification_sectoral) { Mailboxer::Notification.first }
        let(:notification_cge) { Mailboxer::Notification.last }

        before { operator_sectoral && service.call }

        it 'send to cge denunciation' do
          expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: parent.id)

          expect(notification_cge.subject).to eq(I18n.t('shared.notifications.messages.new_ticket.operator.subject.sou', protocol: parent.parent_protocol))
          expect(notification_cge.body).to eq(I18n.t('shared.notifications.messages.new_ticket.operator.body.sou.anonymous', protocol: parent.parent_protocol, url: expected_url))
          expect(denunciation_cge.mailbox.notifications.include?(notification_cge)).to be_truthy
        end

        it 'does not send to cge' do
          expect(operator_cge.mailbox.notifications).to be_empty
        end

        it 'send to sectoral' do
          expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

          expect(notification_sectoral.subject).to eq(I18n.t('shared.notifications.messages.new_ticket.operator.subject.sou', protocol: child.parent_protocol))
          expect(notification_sectoral.body).to eq(I18n.t('shared.notifications.messages.new_ticket.operator.body.sou.anonymous', protocol: child.parent_protocol, url: expected_url))
          expect(operator_sectoral.mailbox.notifications.include?(notification_sectoral)).to be_truthy
        end

      end
    end

    # PLATFORM
    context 'platform' do

      context 'with organ' do
        let(:child) { create(:ticket, :with_parent, created_by: user, organ: organ) }
        let(:parent) { child.parent }
        let(:service) { Notifier::NewTicket.new(parent.id) }
        let(:notification_operator) { Mailboxer::Notification.first }

        let(:expected_url) { url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id) }

        before { operator_sectoral && service.call }

        it 'send to operator' do
          expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.new_ticket.operator.subject.sou', protocol: child.parent_protocol))
          expect(notification_operator.body).to eq(I18n.t('shared.notifications.messages.new_ticket.operator.body.sou.identified', name: parent.name, protocol: child.parent_protocol, url: expected_url))
          expect(operator_sectoral.mailbox.notifications.include?(notification_operator)).to be_truthy
        end

        it 'dont send to cge' do
          expect(operator_cge.mailbox.notifications).to be_empty
        end
      end

      context 'unknown_organ' do
        let(:ticket) { create(:ticket, created_by: user) }
        let(:service) { Notifier::NewTicket.new(ticket.id) }
        let(:notification_operator) { Mailboxer::Notification.first }
        let(:notification_user) { Mailboxer::Notification.last }

        let(:expected_url) { url_helpers.url_for(controller: '/platform/tickets', action: 'show', id: ticket.id) }

        before { operator_sectoral && service.call }

        it 'send to user' do
          expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.new_ticket.platform.subject.sou', protocol: ticket.reload.parent_protocol))
          expect(notification_user.body).to eq(I18n.t('shared.notifications.messages.new_ticket.platform.body.sou.identified', name: ticket.name, protocol: ticket.reload.parent_protocol, url: expected_url, password: ticket.plain_password))
          expect(user.mailbox.notifications.include?(notification_user)).to be_truthy
        end

        it 'dont send to cge' do
          expect(operator_cge.mailbox.notifications).to be_empty
        end

      end

      context 'denunciation' do
        let(:ticket) { create(:ticket, :with_parent, :denunciation, created_by: user, organ: organ) }
        let(:service) { Notifier::NewTicket.new(ticket.parent_id) }
        let(:notification_operator) { Mailboxer::Notification.first }

        before { operator_sectoral && service.call }

        it 'send to sectoral' do
          expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: ticket.id)

          expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.new_ticket.operator.subject.sou', protocol: ticket.reload.parent_protocol))
          expect(notification_operator.body).to eq(I18n.t('shared.notifications.messages.new_ticket.operator.body.sou.identified', name: ticket.name, protocol: ticket.reload.parent_protocol, url: expected_url))
          expect(operator_sectoral.mailbox.notifications.include?(notification_operator)).to be_truthy
        end
      end
    end

    # OPERATOR CGE
    context 'operator cge' do

      context 'with organ' do
        let(:child) { create(:ticket, :with_parent, organ: organ) }
        let(:parent) do
          parent = child.parent
          parent.created_by = operator_cge
          parent.save
          parent
        end
        let(:service) { Notifier::NewTicket.new(parent.id) }
        let(:notification_operator) { Mailboxer::Notification.first }
        let(:notification_user) { Mailboxer::Notification.last }

        before { operator_sectoral && service.call }

        it 'send to user' do
          expected_url = url_helpers.url_for(controller: '/ticket_area/tickets', action: 'show', id: parent.id)

          expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.new_ticket.ticket_area.subject.sou', protocol: parent.parent_protocol))
          expect(notification_user.body).to eq(I18n.t('shared.notifications.messages.new_ticket.ticket_area.body.sou.identified', name: parent.name, protocol: parent.parent_protocol, url: expected_url, password: parent.plain_password))
          expect(parent.mailbox.notifications.include?(notification_user)).to be_truthy
        end

        it 'send to sectoral' do
          expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

          expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.new_ticket.operator.subject.sou', protocol: child.parent_protocol))
          expect(notification_operator.body).to eq(I18n.t('shared.notifications.messages.new_ticket.operator.body.sou.identified', name: child.name, protocol: child.parent_protocol, url: expected_url))
          expect(operator_sectoral.mailbox.notifications.include?(notification_operator)).to be_truthy
        end

        it 'dont send to cge' do
          expect(operator_cge.mailbox.notifications).to be_empty
        end

      end

      context 'unknown_organ' do
        let(:ticket) { create(:ticket, created_by: operator_cge) }
        let(:service) { Notifier::NewTicket.new(ticket.id) }
        let(:notification_operator) { Mailboxer::Notification.first }
        let(:notification_user) { Mailboxer::Notification.last }

        before { operator_sectoral && service.call }

        it 'send to user' do
          expected_url = url_helpers.url_for(controller: '/ticket_area/tickets', action: 'show', id: ticket.id)

          expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.new_ticket.ticket_area.subject.sou', protocol: ticket.parent_protocol))
          expect(notification_user.body).to eq(I18n.t('shared.notifications.messages.new_ticket.ticket_area.body.sou.identified', name: ticket.name, protocol: ticket.parent_protocol, url: expected_url, password: ticket.plain_password))
          expect(ticket.mailbox.notifications.include?(notification_user)).to be_truthy
        end
      end

    end

    # OPERATOR SETORIAL
    context 'operator sectoral' do

      let(:other_organ) { create(:executive_organ) }
      let(:other_operator_sectoral) { create(:user, :operator_sectoral, organ: other_organ) }

      context 'with organ' do
        let(:child) { create(:ticket, :with_parent, organ: organ) }
        let(:parent) do
          parent = child.parent
          parent.created_by = other_operator_sectoral
          parent.save
          parent
        end
        let(:service) { Notifier::NewTicket.new(parent.id) }
        let(:notification_operator) { Mailboxer::Notification.first }
        let(:notification_user) { Mailboxer::Notification.last }

        before { operator_sectoral && service.call }

        it 'send to user' do
          expected_url = url_helpers.url_for(controller: '/ticket_area/tickets', action: 'show', id: parent.id)

          expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.new_ticket.ticket_area.subject.sou', protocol: parent.parent_protocol))
          expect(notification_user.body).to eq(I18n.t('shared.notifications.messages.new_ticket.ticket_area.body.sou.identified', name: parent.name, protocol: parent.parent_protocol, url: expected_url, password: parent.plain_password))
          expect(parent.mailbox.notifications.include?(notification_user)).to be_truthy
        end

        it 'send to sectoral' do
          expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

          expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.new_ticket.operator.subject.sou', protocol: child.parent_protocol))
          expect(notification_operator.body).to eq(I18n.t('shared.notifications.messages.new_ticket.operator.body.sou.identified', name: child.name, protocol: child.parent_protocol, url: expected_url))
          expect(operator_sectoral.mailbox.notifications.include?(notification_operator)).to be_truthy
        end

        it 'dont send to other operator' do
          expect(other_operator_sectoral.mailbox.notifications).to be_empty
        end

        it 'dont send to cge' do
          expect(operator_cge.mailbox.notifications).to be_empty
        end

      end

      context 'unknown_organ' do
        let(:ticket) { create(:ticket, created_by: other_operator_sectoral) }
        let(:service) { Notifier::NewTicket.new(ticket.id) }
        let(:notification_operator) { Mailboxer::Notification.first }
        let(:notification_user) { Mailboxer::Notification.last }

        before { operator_sectoral && service.call }

        it 'send to user' do
          expected_url = url_helpers.url_for(controller: '/ticket_area/tickets', action: 'show', id: ticket.id)

          expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.new_ticket.ticket_area.subject.sou', protocol: ticket.parent_protocol))
          expect(notification_user.body).to eq(I18n.t('shared.notifications.messages.new_ticket.ticket_area.body.sou.identified', name: ticket.name, protocol: ticket.parent_protocol, url: expected_url, password: ticket.plain_password))
          expect(ticket.mailbox.notifications.include?(notification_user)).to be_truthy
        end
      end

    end

    # OPERATOR INTERNO
    context 'operator internal' do

      let(:operator_internal) { create(:user, :operator_internal) }

      context 'with organ' do
        let(:child) { create(:ticket, :with_parent, organ: organ) }
        let(:parent) do
          parent = child.parent
          parent.created_by = operator_internal
          parent.save
          parent
        end
        let(:service) { Notifier::NewTicket.new(parent.id) }
        let(:notification_operator) { Mailboxer::Notification.first }
        let(:notification_user) { Mailboxer::Notification.last }

        before { operator_sectoral && service.call }

        it 'send to user' do
          expected_url = url_helpers.url_for(controller: '/ticket_area/tickets', action: 'show', id: parent.id)

          expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.new_ticket.ticket_area.subject.sou', protocol: parent.parent_protocol))
          expect(notification_user.body).to eq(I18n.t('shared.notifications.messages.new_ticket.ticket_area.body.sou.identified', name: parent.name, protocol: parent.parent_protocol, url: expected_url, password: parent.plain_password))
          expect(parent.mailbox.notifications.include?(notification_user)).to be_truthy
        end

        it 'send to sectoral' do
          expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

          expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.new_ticket.operator.subject.sou', protocol: child.parent_protocol))
          expect(notification_operator.body).to eq(I18n.t('shared.notifications.messages.new_ticket.operator.body.sou.identified', name: child.name, protocol: child.parent_protocol, url: expected_url))
          expect(operator_sectoral.mailbox.notifications.include?(notification_operator)).to be_truthy
        end

        it 'dont send to internal' do
          expect(operator_internal.mailbox.notifications).to be_empty
        end

        it 'dont send to cge' do
          expect(operator_cge.mailbox.notifications).to be_empty
        end

      end

      context 'unknown_organ' do
        let(:ticket) { create(:ticket, created_by: operator_internal) }
        let(:service) { Notifier::NewTicket.new(ticket.id) }
        let(:notification_user) { Mailboxer::Notification.last }

        before { operator_sectoral && service.call }

        it 'send to user' do
          expected_url = url_helpers.url_for(controller: '/ticket_area/tickets', action: 'show', id: ticket.id)

          expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.new_ticket.ticket_area.subject.sou', protocol: ticket.parent_protocol))
          expect(notification_user.body).to eq(I18n.t('shared.notifications.messages.new_ticket.ticket_area.body.sou.identified', name: ticket.name, protocol: ticket.parent_protocol, url: expected_url, password: ticket.plain_password))
          expect(ticket.mailbox.notifications.include?(notification_user)).to be_truthy
        end

        it 'dont send to cge' do
          expect(operator_cge.mailbox.notifications).to be_empty
        end
      end

    end

    # OPERATOR 155
    context 'operator call_center' do

      let(:operator_call_center) { create(:user, :operator_call_center) }

      context 'with organ' do
        let(:child) { create(:ticket, :with_parent, organ: organ) }
        let(:parent) do
          parent = child.parent
          parent.created_by = operator_call_center
          parent.save
          parent
        end
        let(:service) { Notifier::NewTicket.new(parent.id) }
        let(:notification_operator) { Mailboxer::Notification.first }
        let(:notification_user) { Mailboxer::Notification.last }

        before { operator_sectoral && service.call }

        it 'send to user' do
          expected_url = url_helpers.url_for(controller: '/ticket_area/tickets', action: 'show', id: parent.id)

          expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.new_ticket.ticket_area.subject.sou', protocol: parent.parent_protocol))
          expect(notification_user.body).to eq(I18n.t('shared.notifications.messages.new_ticket.ticket_area.body.sou.identified', name: parent.name, protocol: parent.parent_protocol, url: expected_url, password: parent.plain_password))
          expect(parent.mailbox.notifications.include?(notification_user)).to be_truthy
        end

        it 'send to sectoral' do
          expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

          expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.new_ticket.operator.subject.sou', protocol: child.parent_protocol))
          expect(notification_operator.body).to eq(I18n.t('shared.notifications.messages.new_ticket.operator.body.sou.identified', name: child.name, protocol: child.parent_protocol, url: expected_url))
          expect(operator_sectoral.mailbox.notifications.include?(notification_operator)).to be_truthy
        end

        it 'dont send to call center' do
          expect(operator_call_center.mailbox.notifications).to be_empty
        end

        it 'dont send to cge' do
          expect(operator_cge.mailbox.notifications).to be_empty
        end

      end

      context 'unknown_organ' do
        let(:attendance) { create(:attendance, :with_confirmed_ticket) }
        let(:ticket) { attendance.ticket }
        let(:service) { Notifier::NewTicket.new(ticket.id) }
        let(:notification_user) { Mailboxer::Notification.last }

        before { operator_sectoral && service.call }

        it { expect(Mailboxer::Notification.count).to eq(1) }

        it 'send to user' do
          expected_url = url_helpers.url_for(controller: '/ticket_area/tickets', action: 'show', id: ticket.id)

          expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.new_ticket.ticket_area.subject.sou', protocol: ticket.parent_protocol))
          expect(notification_user.body).to eq(I18n.t('shared.notifications.messages.new_ticket.ticket_area.body.sou.identified', name: ticket.name, protocol: ticket.parent_protocol, url: expected_url, password: ticket.plain_password))
          expect(ticket.mailbox.notifications.include?(notification_user)).to be_truthy
        end

        it 'dont send to cge' do
          expect(operator_cge.mailbox.notifications).to be_empty
        end
      end

    end

  end

end
