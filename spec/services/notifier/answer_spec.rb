require 'rails_helper'

describe Notifier::Answer do

  let(:organ) { create(:executive_organ) }
  let(:subnet) { create(:subnet, organ: organ) }
  let(:department) { create(:department, organ: organ) }
  let(:sub_department) { create(:sub_department, department: department) }

  # usuários com notificações habilidatas
  let!(:user) { create(:user, :user) }
  let!(:operator_cge) { create(:user, :operator_cge) }
  let!(:operator_sectoral) { create(:user, :operator_sectoral, organ: organ) }
  let!(:operator_subnet) { create(:user, :operator_subnet, organ: organ, subnet: subnet) }
  let!(:operator_subnet_internal) { create(:user, :operator_subnet_internal, organ: organ, subnet: subnet) }
  let!(:operator_internal) { create(:user, :operator_internal, department: department, organ: department.organ) }
  let!(:operator_sub_department) { create(:user, :operator_internal, department: department, sub_department: sub_department, organ: department.organ) }

  let(:answer) { create(:answer) }

  let(:service) { Notifier::Answer.new(answer.id, nil) }

  let(:url_helpers) { Rails.application.routes.url_helpers }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Notifier::Answer).to receive(:new).with(answer.id, nil) { service }
      allow(service).to receive(:call)
      Notifier::Answer.call(answer.id, nil)

      expect(Notifier::Answer).to have_received(:new).with(answer.id, nil)
      expect(service).to have_received(:call)
    end
  end

  describe 'initialization' do
    it 'responds to notification' do
      expect(service.answer).to be_an_instance_of(Answer)
    end
  end

  describe 'call' do

    # AWAITING
    context 'awaiting' do
      context 'subnet_department' do
        let(:child) { create(:ticket, :with_parent, :with_subnet, created_by: user, organ: organ, subnet: subnet) }
        let(:parent) { child.parent }
        let(:answer) { create(:answer, :awaiting_subnet_department, ticket: child) }
        let!(:ticket_log) { create(:ticket_log, ticket: child, resource: answer, responsible: operator_subnet_internal) }
        let(:service) { Notifier::Answer.new(answer.id, operator_subnet_internal.id) }
        let(:expected_url) { url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id) }
        let(:notification) { Mailboxer::Notification.last }

        before { service.call }

        it { expect(Mailboxer::Notification.count).to eq(1) }

        it 'send to sectoral' do
          expect(notification.subject).to eq(I18n.t('shared.notifications.messages.answer.operator.awaiting.subject.sou', protocol: child.parent_protocol))
          expect(notification.body).to eq(I18n.t('shared.notifications.messages.answer.operator.awaiting.body.sou', user_name: operator_subnet_internal.name, protocol: child.parent_protocol, url: expected_url))
          expect(operator_subnet.mailbox.notifications.include?(notification)).to be_truthy
        end
      end

      context 'subnet' do
        let(:child) { create(:ticket, :with_parent, :with_subnet, created_by: user, organ: organ, subnet: subnet) }
        let(:parent) { child.parent }
        let(:answer) { create(:answer, :awaiting_subnet, ticket: child) }
        let!(:ticket_log) { create(:ticket_log, ticket: child, resource: answer, responsible: operator_subnet) }
        let(:service) { Notifier::Answer.new(answer.id, operator_subnet.id) }
        let(:expected_url) { url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id) }
        let(:notification) { Mailboxer::Notification.last }

        before { service.call }

        it { expect(Mailboxer::Notification.count).to eq(1) }

        it 'send to sectoral' do
          expect(notification.subject).to eq(I18n.t('shared.notifications.messages.answer.operator.awaiting.subject.sou', protocol: child.parent_protocol))
          expect(notification.body).to eq(I18n.t('shared.notifications.messages.answer.operator.awaiting.body.sou', user_name: operator_subnet.name, protocol: child.parent_protocol, url: expected_url))
          expect(operator_sectoral.mailbox.notifications.include?(notification)).to be_truthy
        end
      end

      context 'department' do
        let(:child) { create(:ticket, :with_parent, created_by: user, organ: organ) }
        let(:parent) { child.parent }
        let(:answer) { create(:answer, :awaiting_department, ticket: child) }
        let!(:ticket_log) { create(:ticket_log, ticket: child, resource: answer, responsible: operator_internal) }
        let(:service) { Notifier::Answer.new(answer.id, operator_internal.id) }
        let(:expected_url) { url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id) }
        let(:notification) { Mailboxer::Notification.last }

        before { service.call }

        it { expect(Mailboxer::Notification.count).to eq(1) }

        it 'send to sectoral' do
          expect(notification.subject).to eq(I18n.t('shared.notifications.messages.answer.operator.awaiting.subject.sou', protocol: child.parent_protocol))
          expect(notification.body).to eq(I18n.t('shared.notifications.messages.answer.operator.awaiting.body.sou', user_name: operator_internal.name, protocol: child.parent_protocol, url: expected_url))
          expect(operator_sectoral.mailbox.notifications.include?(notification)).to be_truthy
        end
      end

      context 'sectoral' do
        let(:child) { create(:ticket, :with_parent, created_by: user, organ: organ) }
        let(:parent) { child.parent }
        let(:answer) { create(:answer, :awaiting_sectoral, ticket: child) }
        let!(:ticket_log) { create(:ticket_log, ticket: child, resource: answer, responsible: operator_internal) }
        let(:service) { Notifier::Answer.new(answer.id, operator_sectoral.id) }
        let(:expected_url) { url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: parent.id) }
        let(:notification) { Mailboxer::Notification.last }

        before { service.call }

        it { expect(Mailboxer::Notification.count).to eq(1) }

        it 'send to cge' do
          expect(notification.subject).to eq(I18n.t('shared.notifications.messages.answer.operator.awaiting.subject.sou', protocol: parent.parent_protocol))
          expect(notification.body).to eq(I18n.t('shared.notifications.messages.answer.operator.awaiting.body.sou', user_name: operator_sectoral.name, protocol: parent.parent_protocol, url: expected_url))
          expect(operator_cge.mailbox.notifications.include?(notification)).to be_truthy
        end
      end
    end

    # SUBNET_APPROVED
    context 'subnet_approved' do
      let(:child) { create(:ticket, :with_parent, created_by: user, organ: organ) }
      let(:parent) { child.parent }
      let(:answer) { create(:answer, :subnet_approved, ticket: child) }
      let!(:ticket_log) { create(:ticket_log, ticket: child, resource: answer, responsible: operator_subnet_internal, data: {responsible_department_id: operator_subnet_internal.department_id }) }
      let(:service) { Notifier::Answer.new(answer.id, operator_subnet.id) }
      let(:expected_url) { url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id) }
      let(:notification) { Mailboxer::Notification.last }

      before { service.call }

      it { expect(Mailboxer::Notification.count).to eq(1) }

      it 'send to internal' do
        expect(notification.subject).to eq(I18n.t('shared.notifications.messages.answer.operator.subnet_approved.subject.sou', protocol: child.parent_protocol))
        expect(notification.body).to eq(I18n.t('shared.notifications.messages.answer.operator.subnet_approved.body.sou', user_name: operator_subnet.name, protocol: child.parent_protocol, url: expected_url))
        expect(operator_subnet_internal.mailbox.notifications.include?(notification)).to be_truthy
      end
    end

    # SUBNET_REJECTED
    context 'subnet_rejected' do
      let(:child) { create(:ticket, :with_parent, organ: organ) }
      let(:parent) { child.parent }
      let(:answer) { create(:answer, :subnet_rejected, ticket: child) }
      let!(:ticket_log) { create(:ticket_log, ticket: child, resource: answer, responsible: operator_subnet_internal, data: {responsible_department_id: operator_subnet_internal.department_id }) }
      let(:service) { Notifier::Answer.new(answer.id, operator_subnet.id) }
      let(:expected_url) { url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id) }
      let(:notification) { Mailboxer::Notification.last }

      before { service.call }

      it { expect(Mailboxer::Notification.count).to eq(1) }

      it 'send to internal' do
        expect(notification.subject).to eq(I18n.t('shared.notifications.messages.answer.operator.sectoral_rejected.subject.sou', protocol: child.parent_protocol))
        expect(notification.body).to eq(I18n.t('shared.notifications.messages.answer.operator.sectoral_rejected.body.sou', user_name: operator_subnet.name, protocol: child.parent_protocol, url: expected_url))
        expect(operator_subnet_internal.mailbox.notifications.include?(notification)).to be_truthy
      end
    end

    # SECTORAL_APRROVED
    context 'sectoral_approved' do
      let(:child) { create(:ticket, :with_parent, created_by: user, organ: organ) }
      let(:parent) { child.parent }
      let(:answer) { create(:answer, :sectoral_approved, ticket: child) }
      let!(:ticket_log) { create(:ticket_log, ticket: child, resource: answer, responsible: operator_internal, data: {responsible_department_id: operator_internal.department_id }) }
      let(:service) { Notifier::Answer.new(answer.id, operator_sectoral.id) }
      let(:expected_url) { url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id) }
      let(:notification) { Mailboxer::Notification.last }
      let(:ticket_department) { create(:ticket_department, ticket: child, department: department) }


      it 'send to internal' do
        service.call
        expect(Mailboxer::Notification.count).to eq(1)
        expect(notification.subject).to eq(I18n.t('shared.notifications.messages.answer.operator.sectoral_approved.subject.sou', protocol: child.parent_protocol))
        expect(notification.body).to eq(I18n.t('shared.notifications.messages.answer.operator.sectoral_approved.body.sou', user_name: operator_sectoral.name, protocol: child.parent_protocol, url: expected_url))
        expect(operator_internal.mailbox.notifications.include?(notification)).to be_truthy
      end

      it 'send to internal sub_department' do
        create(:ticket_department_sub_department, ticket_department: ticket_department, sub_department: sub_department)
        service.call
        expect(Mailboxer::Notification.count).to eq(1)
        expect(notification.subject).to eq(I18n.t('shared.notifications.messages.answer.operator.sectoral_approved.subject.sou', protocol: child.parent_protocol))
        expect(notification.body).to eq(I18n.t('shared.notifications.messages.answer.operator.sectoral_approved.body.sou', user_name: operator_sectoral.name, protocol: child.parent_protocol, url: expected_url))
        expect(operator_sub_department.mailbox.notifications.include?(notification)).to be_truthy
      end
    end

    # SECTORAL_REJECTED
    context 'sectoral_rejected' do
      let(:child) { create(:ticket, :with_parent, organ: organ) }
      let(:parent) { child.parent }
      let(:answer) { create(:answer, :sectoral_rejected, ticket: child) }
      let!(:ticket_log) { create(:ticket_log, ticket: child, resource: answer, responsible: operator_internal, data: {responsible_department_id: operator_internal.department_id }) }
      let(:service) { Notifier::Answer.new(answer.id, operator_sectoral.id) }
      let(:expected_url) { url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id) }
      let(:notification) { Mailboxer::Notification.last }

      before { service.call }

      context 'department' do

        it { expect(Mailboxer::Notification.count).to eq(1) }

        it 'send to internal' do
          expect(notification.subject).to eq(I18n.t('shared.notifications.messages.answer.operator.sectoral_rejected.subject.sou', protocol: child.parent_protocol))
          expect(notification.body).to eq(I18n.t('shared.notifications.messages.answer.operator.sectoral_rejected.body.sou', user_name: operator_sectoral.name, protocol: child.parent_protocol, url: expected_url))
          expect(operator_internal.mailbox.notifications.include?(notification)).to be_truthy
        end
      end

      context 'subnet_department' do
        let(:organ) { create(:executive_organ, :with_subnet) }
        let(:child) { create(:ticket, :with_parent, :with_subnet, subnet: subnet) }

        let!(:ticket_log) { create(:ticket_log, ticket: child, resource: answer, responsible: operator_subnet) }

        it { expect(Mailboxer::Notification.count).to eq(1) }

        it 'send to internal' do
          expect(notification.subject).to eq(I18n.t('shared.notifications.messages.answer.operator.sectoral_rejected.subject.sou', protocol: child.parent_protocol))
          expect(notification.body).to eq(I18n.t('shared.notifications.messages.answer.operator.sectoral_rejected.body.sou', user_name: operator_sectoral.name, protocol: child.parent_protocol, url: expected_url))
          expect(operator_subnet.mailbox.notifications.include?(notification)).to be_truthy
        end
      end
    end

    # CGE_APPROVED
    context 'cge_approved' do
      let(:child) { create(:ticket, :with_parent, organ: organ) }
      let(:parent) { child.parent }
      let(:answer) { create(:answer, :with_cge_approved_final_answer, ticket: parent) }
      let(:service) { Notifier::Answer.new(answer.id, operator_cge.id) }
      let(:expected_url) { url_helpers.url_for(controller: '/ticket_area/tickets', action: 'show', id: parent.id) }
      let(:notification) { Mailboxer::Notification.last }

      before { service.call }

      it { expect(Mailboxer::Notification.count).to eq(1) }

      it 'send to user' do
        expect(notification.subject).to eq(I18n.t('shared.notifications.messages.answer.ticket_area.cge_approved.subject.sou', protocol: parent.parent_protocol))
        expect(notification.body).to eq(I18n.t('shared.notifications.messages.answer.ticket_area.cge_approved.body.sou', user_name: operator_cge.name, protocol: parent.parent_protocol, url: expected_url, answer_description: answer.description))
        expect(parent.mailbox.notifications.include?(notification)).to be_truthy
      end
    end

    # CGE_REJECTED
    context 'cge_rejected' do
      let(:child) { create(:ticket, :with_parent, organ: organ) }
      let(:parent) { child.parent }
      let(:answer) { create(:answer, :cge_rejected, ticket: child) }
      let(:service) { Notifier::Answer.new(answer.id, operator_cge.id) }
      let(:expected_url) { url_helpers.url_for(controller: '/operator/tickets', action: 'show', id: child.id) }
      let(:notification) { Mailboxer::Notification.last }

      before { service.call }

      context 'sectoral' do
        it { expect(Mailboxer::Notification.count).to eq(1) }

        it 'send to sectoral' do
          expect(notification.subject).to eq(I18n.t('shared.notifications.messages.answer.operator.cge_rejected.subject.sou', protocol: child.parent_protocol))
          expect(notification.body).to eq(I18n.t('shared.notifications.messages.answer.operator.cge_rejected.body.sou', user_name: operator_cge.name, protocol: child.parent_protocol, url: expected_url))
          expect(operator_sectoral.mailbox.notifications.include?(notification)).to be_truthy
        end
      end

      context 'subnet' do
        let(:organ) { create(:executive_organ, :with_subnet) }
        let(:child) { create(:ticket, :with_parent, :with_subnet, subnet: subnet) }
        let(:answer) { create(:answer, :cge_rejected, ticket: child) }

        let!(:ticket_log) { create(:ticket_log, ticket: child, resource: answer, responsible: operator_subnet) }

        it { expect(Mailboxer::Notification.count).to eq(1) }

        it 'send to internal' do
          expect(notification.subject).to eq(I18n.t('shared.notifications.messages.answer.operator.cge_rejected.subject.sou', protocol: child.parent_protocol))
          expect(notification.body).to eq(I18n.t('shared.notifications.messages.answer.operator.cge_rejected.body.sou', user_name: operator_cge.name, protocol: child.parent_protocol, url: expected_url))
          expect(operator_subnet.mailbox.notifications.include?(notification)).to be_truthy
        end
      end
    end

  end

end
