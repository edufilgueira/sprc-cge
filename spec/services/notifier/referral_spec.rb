require 'rails_helper'

describe Notifier::Referral do
  let(:organ) { create(:executive_organ) }
  let(:department) { create(:department, organ: organ) }
  let(:sub_department) { create(:sub_department, department: department) }

  # usuários com notificações habilidatas
  let!(:user) { create(:user, :user) }
  let!(:operator_sectoral) { create(:user, :operator_sectoral, organ: organ) }
  let!(:operator_internal) { create(:user, :operator_internal, department: department, organ: department.organ) }
  let!(:operator_sub_department) { create(:user, :operator_internal, department: department, sub_department: sub_department, organ: department.organ) }

  # usuários com notificações desabilidadas
  let!(:operator_sectoral_blocked_notifications) { create(:user, :operator_sectoral, :blocked_notifications, organ: organ) }

  let(:ticket) { create(:ticket) }

  let(:service) { Notifier::Referral.new(ticket.id, department.id, user.id) }

  let(:url_helpers) { Rails.application.routes.url_helpers }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Notifier::Referral).to receive(:new).with(ticket.id, department.id, user.id) { service }
      allow(service).to receive(:call)
      Notifier::Referral.call(ticket.id, department.id, user.id)

      expect(Notifier::Referral).to have_received(:new).with(ticket.id, department.id, user.id)
      expect(service).to have_received(:call)
    end
  end

  describe 'initialization' do
    it 'responds to notification' do
      expect(service.ticket).to be_an_instance_of(Ticket)
    end
  end

  describe 'call' do

    context 'department' do

      # TICKET
      context 'ticket' do
        let(:child) { create(:ticket, :with_parent, organ: organ) }
        let(:parent) { child.parent }
        let(:service) { Notifier::Referral.new(child.id, department.id, operator_sectoral.id) }
        let(:notification_operator) { Mailboxer::Notification.first }
        let(:notification_user) { Mailboxer::Notification.last }

        let(:ticket_department) { create(:ticket_department, ticket: child, department: department, considerations: considerations) }
        let(:considerations) { 'Operator considerations' }

        before do
          ticket_department
          service.call
        end

        it 'send to user' do
          expected_url = url_helpers.url_for(controller: '/ticket_area/tickets', action: 'show', id: parent.id)

          expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.referral.ticket_area.subject.sou', protocol: parent.parent_protocol))
          expect(notification_user.body).to eq(I18n.t("shared.notifications.messages.referral.ticket_area.body.sou", department_name: department.title, protocol: parent.parent_protocol, url: expected_url))
          expect(parent.mailbox.notifications.include?(notification_user)).to be_truthy
        end

        context 'send to operator' do
          let(:expected_url) { url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id) }
          let(:expected_considerations) { ticket_department.considerations }
          let(:expected_body_params) do
            {
              user_name: operator_sectoral.name,
              department_name: department.title,
              protocol: child.parent_protocol,
              url: expected_url,
              considerations: expected_considerations
            }
          end

          it 'with considerations' do
            expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.referral.operator.subject.sou', protocol: child.parent_protocol))
            expect(notification_operator.body).to eq(I18n.t("shared.notifications.messages.referral.operator.body.sou", expected_body_params))
            expect(operator_internal.mailbox.notifications.include?(notification_operator)).to be_truthy
          end

          context 'without considerations' do
            let(:considerations) { '' }
            let(:expected_considerations) { I18n.t('shared.notifications.messages.referral.operator.considerations.empty') }

            it { expect(notification_operator.body).to eq(I18n.t("shared.notifications.messages.referral.operator.body.sou", expected_body_params)) }
          end
        end
      end

      # PLATFORM
      context 'platform' do
        let(:child) { create(:ticket, :with_parent, organ: organ) }
        let!(:parent) do
          parent = child.parent
          parent.update_attributes(created_by: user)
          parent
        end
        let(:service) { Notifier::Referral.new(child.id, department.id, operator_internal.id) }
        let(:notification_operator) { Mailboxer::Notification.first }
        let(:notification_user) { Mailboxer::Notification.last }

        let(:ticket_department) { create(:ticket_department, ticket: child, department: department, considerations: considerations) }
        let(:considerations) { 'Operator considerations' }

        before do
          ticket_department
          service.call
        end

        it 'send to user' do
          expected_url = url_helpers.url_for(controller: '/platform/tickets', action: 'show', id: parent.id)

          expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.referral.platform.subject.sou', protocol: parent.parent_protocol))
          expect(notification_user.body).to eq(I18n.t("shared.notifications.messages.referral.platform.body.sou", department_name: department.title, protocol: parent.parent_protocol, url: expected_url))
          expect(user.mailbox.notifications.include?(notification_user)).to be_truthy
        end

        context 'send to operator' do
          let(:expected_url) { url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id) }
          let(:expected_considerations) { ticket_department.considerations }
          let(:expected_body_params) do
            {
              user_name: operator_internal.name,
              department_name: department.title,
              protocol: child.parent_protocol,
              url: expected_url,
              considerations: expected_considerations
            }
          end

          it 'with considerations' do
            expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.referral.operator.subject.sou', protocol: child.parent_protocol))
            expect(notification_operator.body).to eq(I18n.t("shared.notifications.messages.referral.operator.body.sou", expected_body_params))
            expect(operator_internal.mailbox.notifications.include?(notification_operator)).to be_truthy
          end

          context 'without considerations' do
            let(:considerations) { '' }
            let(:expected_considerations) { I18n.t('shared.notifications.messages.referral.operator.considerations.empty') }

            it { expect(notification_operator.body).to eq(I18n.t("shared.notifications.messages.referral.operator.body.sou", expected_body_params)) }
          end
        end
      end

    end

    context 'sub_department' do

      # TICKET
      context 'ticket' do
        let(:child) { create(:ticket, :with_parent, organ: organ) }
        let(:parent) { child.parent }
        let(:service) { Notifier::Referral.new(child.id, department.id, operator_sectoral.id) }
        let(:notification_operator) { Mailboxer::Notification.first }
        let(:notification_user) { Mailboxer::Notification.last }
        let(:ticket_department) { create(:ticket_department, ticket: child, department: department, considerations: considerations) }
        let(:considerations) { 'Operator considerations' }
        let!(:ticket_department_subdepartment) { create(:ticket_department_sub_department, ticket_department: ticket_department, sub_department: sub_department) }


        before do
          ticket_department_subdepartment
          service.call
        end

        it 'send to user' do
          expected_url = url_helpers.url_for(controller: '/ticket_area/tickets', action: 'show', id: parent.id)

          expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.referral.ticket_area.subject.sou', protocol: parent.parent_protocol))
          expect(notification_user.body).to eq(I18n.t("shared.notifications.messages.referral.ticket_area.body.sou", department_name: department.title, protocol: parent.parent_protocol, url: expected_url))
          expect(parent.mailbox.notifications.include?(notification_user)).to be_truthy
        end

        context 'send to operator' do
          let(:expected_url) { url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id) }
          let(:expected_considerations) { ticket_department.considerations }
          let(:expected_body_params) do
            {
              user_name: operator_sectoral.name,
              department_name: department.title,
              protocol: child.parent_protocol,
              url: expected_url,
              considerations: expected_considerations
            }
          end

          it 'with considerations' do
            expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.referral.operator.subject.sou', protocol: child.parent_protocol))
            expect(notification_operator.body).to eq(I18n.t("shared.notifications.messages.referral.operator.body.sou", expected_body_params))
            expect(operator_internal.mailbox.notifications).to be_empty
            expect(operator_sub_department.mailbox.notifications.include?(notification_operator)).to be_truthy
          end

          context 'without considerations' do
            let(:considerations) { '' }
            let(:expected_considerations) { I18n.t('shared.notifications.messages.referral.operator.considerations.empty') }

            it { expect(notification_operator.body).to eq(I18n.t("shared.notifications.messages.referral.operator.body.sou", expected_body_params)) }
          end
        end
      end

    end
  end
end
