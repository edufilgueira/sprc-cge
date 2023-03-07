require 'rails_helper'

describe Notifier::AttendanceAllocation do

  let(:organ) { create(:executive_organ) }

  let!(:user_call_center) { create(:user, :operator_call_center) }

  let(:ticket) { create(:ticket) }

  let(:service) { Notifier::AttendanceAllocation.new(ticket.id, user_call_center.id) }

  let(:url_helpers) { Rails.application.routes.url_helpers }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Notifier::AttendanceAllocation).to receive(:new).with(ticket.id, user_call_center.id) { service }
      allow(service).to receive(:call)
      Notifier::AttendanceAllocation.call(ticket.id, user_call_center.id)

      expect(Notifier::AttendanceAllocation).to have_received(:new).with(ticket.id, user_call_center.id)
      expect(service).to have_received(:call)
    end
  end

  describe 'initialization' do
    it 'responds to notification' do
      expect(service.ticket).to be_an_instance_of(Ticket)
      expect(service.user_call_center).to be_an_instance_of(User)
    end
  end

  describe 'call' do

    # TICKET AREA
    context 'ticket_area' do

      let(:child) { create(:ticket, :with_parent, :anonymous, organ: organ) }
      let(:parent) do
        parent = child.parent
        parent.anonymous = true
        parent.save
        parent
      end
      let(:service) { Notifier::AttendanceAllocation.new(parent.id, user_call_center.id) }
      let(:notification_operator) { Mailboxer::Notification.first }
      let(:notification_user) { Mailboxer::Notification.last }

      before { service.call }

      it { expect(Mailboxer::Notification.count).to eq(2) }

      it 'send to user' do
        expected_url = url_helpers.url_for(controller: '/ticket_area/tickets', action: 'show', id: parent.id)

        expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.attendance_allocation.ticket_area.subject.sou', protocol: parent.parent_protocol))
        expect(notification_user.body).to eq(I18n.t("shared.notifications.messages.attendance_allocation.ticket_area.body.sou", protocol: parent.parent_protocol, url: expected_url))
        expect(parent.mailbox.notifications.include?(notification_user)).to be_truthy
      end

      it 'send to operator' do
        expected_url = url_helpers.url_for(controller: '/operator/call_center_tickets', action: 'show', id: parent.id)

        expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.attendance_allocation.operator.subject.sou', protocol: parent.parent_protocol))
        expect(notification_operator.body).to eq(I18n.t('shared.notifications.messages.attendance_allocation.operator.body.sou', protocol: parent.parent_protocol, url: expected_url))
        expect(user_call_center.mailbox.notifications.include?(notification_operator)).to be_truthy
      end

    end

    # PLATFORM
    context 'platform' do

      let(:child) { create(:ticket, :with_parent, organ: organ) }
      let(:user) { create(:user, :user) }
      let(:parent) do
        parent = child.parent
        parent.update_column(:created_by_id, user.id)
        parent
      end
      let(:service) { Notifier::AttendanceAllocation.new(parent.id, user_call_center.id) }
      let(:notification_operator) { Mailboxer::Notification.first }
      let(:notification_user) { Mailboxer::Notification.last }

      before { service.call }

      it { expect(Mailboxer::Notification.count).to eq(2) }

      it 'send to user' do
        expected_url = url_helpers.url_for(controller: '/platform/tickets', action: 'show', id: parent.id)

        expect(notification_user.subject).to eq(I18n.t('shared.notifications.messages.attendance_allocation.platform.subject.sou', protocol: parent.parent_protocol))
        expect(notification_user.body).to eq(I18n.t("shared.notifications.messages.attendance_allocation.platform.body.sou", protocol: parent.parent_protocol, url: expected_url))
        expect(user.mailbox.notifications.include?(notification_user)).to be_truthy
      end

      it 'send to operator' do
        expected_url = url_helpers.url_for(controller: '/operator/call_center_tickets', action: 'show', id: parent.id)

        expect(notification_operator.subject).to eq(I18n.t('shared.notifications.messages.attendance_allocation.operator.subject.sou', protocol: parent.parent_protocol))
        expect(notification_operator.body).to eq(I18n.t('shared.notifications.messages.attendance_allocation.operator.body.sou', protocol: parent.parent_protocol, url: expected_url))
        expect(user_call_center.mailbox.notifications.include?(notification_operator)).to be_truthy
      end

    end

  end

end
