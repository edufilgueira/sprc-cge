require 'rails_helper'

describe Notifier::Deadline do
  let(:organ) { create(:executive_organ) }
  let(:department) { create(:department, organ: organ) }
  let(:sub_department) { create(:sub_department, department: department) }

  let!(:user) { create(:user, :user) }
  let!(:operator_cge) { create(:user, :operator_cge) }
  let!(:operator_sectoral) { create(:user, :operator_sectoral, organ: organ) }
  let!(:operator_internal) { create(:user, :operator_internal, department: department, organ: department.organ) }
  let!(:operator_subdepartment) { create(:user, :operator_internal, department: department, sub_department: sub_department, organ: department.organ) }

  let(:ticket) { create(:ticket) }

  let(:service) { Notifier::Deadline.new(ticket.id) }

  let(:url_helpers) { Rails.application.routes.url_helpers }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Notifier::Deadline).to receive(:new).with(ticket.id) { service }
      allow(service).to receive(:call)
      Notifier::Deadline.call(ticket.id)

      expect(Notifier::Deadline).to have_received(:new).with(ticket.id)
      expect(service).to have_received(:call)
    end
  end

  describe 'initialization' do
    it 'responds to notification' do
      expect(service.ticket).to be_an_instance_of(Ticket)
    end
  end

  describe 'call' do

    context 'parent' do

      context 'platform' do
        context 'deadline_notificable' do
          let(:deadline_notificable) { -1 }
          let(:child) { create(:ticket, :with_parent, organ: organ) }
          let(:parent) do
            parent = child.parent
            parent.created_by = user
            parent.deadline = deadline_notificable
            parent.save
            parent
          end
          let(:service) { Notifier::Deadline.new(parent.id) }
          let(:notification_operator) { Mailboxer::Notification.first }
          let(:notification_user) { Mailboxer::Notification.last }

          before { service.call }

          it {expect(Mailboxer::Notification.count).to be(2) }

          it 'send to operator' do
            expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: parent.id)

            expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.deadline.late.subject', protocol: parent.parent_protocol))
            expect(notification_operator.body).to eq(I18n.t('shared.notifications.messages.deadline.late.body', deadline: parent.deadline.abs, protocol: parent.parent_protocol, url: expected_url))
            expect(operator_cge.mailbox.notifications.include?(notification_operator)).to be_truthy
          end

          it 'send to user' do
            expected_url = url_helpers.url_for(controller: '/platform/tickets', action: 'show', id: parent.id)

            expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.deadline.late.subject', protocol: parent.parent_protocol))
            expect(notification_user.body).to eq(I18n.t('shared.notifications.messages.deadline.late.body', deadline: parent.deadline.abs, protocol: parent.parent_protocol, url: expected_url))
            expect(user.mailbox.notifications.include?(notification_user)).to be_truthy
          end
        end

        context 'deadline_not_notificable' do
          let(:deadline_not_notificable) { 7 }
          let(:child) { create(:ticket, :with_parent, organ: organ) }
          let(:parent) do
            parent = child.parent
            parent.created_by = user
            parent.deadline = deadline_not_notificable
            parent.save
            parent
          end
          let(:service) { Notifier::Deadline.new(parent.id) }

          before { service.call }

          it {expect(Mailboxer::Notification.count).to be(0) }
        end
      end

      context 'ticket' do
        let(:deadline_notificable) { 5 }
        let(:child) { create(:ticket, :with_parent, organ: organ) }
        let(:parent) do
          parent = child.parent
          parent.deadline = deadline_notificable
          parent.save
          parent
        end
        let(:service) { Notifier::Deadline.new(parent.id) }
        let(:notification_operator) { Mailboxer::Notification.first }
        let(:notification_user) { Mailboxer::Notification.last }

        before { service.call }

        it {expect(Mailboxer::Notification.count).to be(2) }

        it 'send to operator' do
          expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: parent.id)

          expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.deadline.in_time.subject', protocol: parent.parent_protocol))
          expect(notification_operator.body).to eq(I18n.t('shared.notifications.messages.deadline.in_time.body', deadline: parent.deadline, protocol: parent.parent_protocol, url: expected_url))
          expect(operator_cge.mailbox.notifications.include?(notification_operator)).to be_truthy
        end

        it 'send to user' do
          expected_url = url_helpers.url_for(controller: '/ticket_area/tickets', action: 'show', id: parent.id)

          expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.deadline.in_time.subject', protocol: parent.parent_protocol))
          expect(notification_user.body).to eq(I18n.t('shared.notifications.messages.deadline.in_time.body', deadline: parent.deadline, protocol: parent.parent_protocol, url: expected_url))
          expect(parent.mailbox.notifications.include?(notification_user)).to be_truthy
        end
      end
    end


    context 'child' do

      context 'operator' do

        context 'status_notificable' do
          let(:deadline_notificable) { 5 }
          let(:child) { create(:ticket, :with_parent, internal_status: :sectoral_attendance, organ: organ, deadline: deadline_notificable) }
          let(:service) { Notifier::Deadline.new(child.id) }
          let(:notification_operator) { Mailboxer::Notification.last }

          before { service.call }

          it 'send to sectoral' do
            expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

            expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.deadline.in_time.subject', protocol: child.parent_protocol))
            expect(notification_operator.body).to eq(I18n.t('shared.notifications.messages.deadline.in_time.body', deadline: child.deadline, protocol: child.parent_protocol, url: expected_url))
            expect(operator_sectoral.mailbox.notifications.include?(notification_operator)).to be_truthy
          end
        end

        context 'status_not_notificable' do
          let(:deadline_notificable) { 5 }
          let(:child) { create(:ticket, :with_parent, organ: organ, internal_status: :cge_validation, deadline: deadline_notificable) }
          let(:service) { Notifier::Deadline.new(child.id) }
          let(:notification_operator) { Mailboxer::Notification.last }

          before { service.call }

          it 'dont send to sectoral' do
            expect(operator_sectoral.mailbox.notifications.include?(notification_operator)).to be_falsey
          end
        end

      end

      context 'department' do

        context 'not_answered' do
          let(:child) { create(:ticket, :with_parent, internal_status: :internal_attendance, organ: organ) }
          let(:not_answered) { 'not_answered' }
          let(:deadline_notificable) { 5 }
          let!(:ticket_department) { create(:ticket_department, department: department, ticket: child, answer: not_answered, deadline: deadline_notificable) }
          let(:service) { Notifier::Deadline.new(child.id) }
          let(:notification_department) { Mailboxer::Notification.last }

          it 'send to internal' do
            expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

            service.call

            expect(Mailboxer::Notification.count).to be(1)
            expect(notification_department.subject).to eq(I18n.t('shared.notifications.messages.deadline.in_time.subject', protocol: child.parent_protocol))
            expect(notification_department.body).to eq(I18n.t('shared.notifications.messages.deadline.in_time.body', deadline: 5, protocol: child.parent_protocol, url: expected_url))
            expect(operator_internal.mailbox.notifications.include?(notification_department)).to be_truthy
          end

          it 'send to sub_department internal' do
            expected_url = url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id)

            create(:ticket_department_sub_department, ticket_department: ticket_department, sub_department: sub_department)

            service.call

            expect(Mailboxer::Notification.count).to be(1)
            expect(notification_department.subject).to eq(I18n.t('shared.notifications.messages.deadline.in_time.subject', protocol: child.parent_protocol))
            expect(notification_department.body).to eq(I18n.t('shared.notifications.messages.deadline.in_time.body', deadline: 5, protocol: child.parent_protocol, url: expected_url))
            expect(operator_subdepartment.mailbox.notifications.include?(notification_department)).to be_truthy
          end
        end

        context 'answered' do
          let(:child) { create(:ticket, :with_parent, internal_status: :internal_attendance, organ: organ) }
          let(:answered) { 'answered' }
          let(:deadline_notificable) { 5 }
          let(:ticket_department) { create(:ticket_department, department: department, ticket: child, answer: answered, deadline: deadline_notificable) }
          let(:service) { Notifier::Deadline.new(child.id) }

          before { service.call }

          it {expect(Mailboxer::Notification.count).to be(0) }
        end

        context 'deadline_not_notificable' do
          let(:child) { create(:ticket, :with_parent, internal_status: :internal_attendance, organ: organ) }
          let(:not_answered) { 'not_answered' }
          let(:deadline_not_notificable) { 7 }
          let(:ticket_department) { create(:ticket_department, department: department, ticket: child, answer: not_answered, deadline: deadline_not_notificable) }
          let(:service) { Notifier::Deadline.new(child.id) }

          before { service.call }

          it {expect(Mailboxer::Notification.count).to be(0) }
        end

      end

    end

  end
end
