require 'rails_helper'

describe Answer::RejectionService do
    let(:service) { Answer::RejectionService.new(answer, user, justification) }
    let(:answer) { create(:answer, :child_ticket) }
    let(:ticket) { answer.ticket }
    let(:parent) { ticket.parent }
    let(:justification) { 'Lorem' }
    let(:user) { create(:user, :operator_cge) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      justification_service = double

      allow(Answer::RejectionService).to receive(:new) { justification_service }
      allow(justification_service).to receive(:call)

      Answer::RejectionService.call(answer, user, justification)

      expect(Answer::RejectionService).to have_received(:new).with(answer, user, justification)
      expect(justification_service).to have_received(:call)
    end
  end

  describe 'initialization' do
    it 'responds to answer' do
      expect(service.answer).to eq(answer)
    end
    it 'responds to ticket' do
      expect(service.ticket).to eq(ticket)
    end
    it 'responds to parent_ticket' do
      expect(service.parent_ticket).to eq(parent)
    end
    it 'responds to justification' do
      expect(service.justification).to eq(justification)
    end
    it 'responds to user' do
      expect(service.user).to eq(user)
    end

  end

  describe 'call' do

    context 'when operator subnet' do
      let(:user) { create(:user, :operator_subnet) }
      let(:internal_user) { create(:user, :operator_subnet_internal) }
      let(:ticket_log) do
        create(:ticket_log, :with_final_answer, responsible: internal_user,
          resource: answer, ticket: ticket, data: data)
      end

      let(:data) do
        {
          responsible_department_id: internal_user.department_id,
          responsible_subnet_id: internal_user.subnet_id
        }
      end
      let(:ticket_department) do
        create(:ticket_department, ticket: ticket,
          department: internal_user.department, answer: :answered)
      end

      let(:ticket_department_email) { create(:ticket_department_email, ticket_department: ticket_department) }
      let(:created_ticket_department_email) { TicketDepartmentEmail.last }

      let(:notifier) { double }

      before do
        ticket_department
        ticket_log

        allow(Notifier::Referral::AdditionalUserRejected).to receive(:delay) { notifier }
        allow(notifier).to receive(:call)

        ticket_department_email

        service.call
      end

      it 'update answer_status' do

        expect(answer.reload.subnet_rejected?).to be_truthy
      end

      it 'ticket status' do
        expect(ticket.reload.internal_attendance?).to be_truthy
      end

      it 'changes ticket_department to not_answered ' do
        expect(ticket_department.reload).to be_not_answered
      end

      it 'notify additional users' do
        expect(notifier).to have_received(:call).with(ticket.id, created_ticket_department_email.id, user.id, justification)
      end

      it 'identify who reject answer' do
        ticket_log.reload
        expect(ticket_log.data[:responsible_user_evaluated_answer_id]).to eq(user.id)
      end
    end

    context 'when operator sectoral' do
      let(:user) { create(:user, :operator_sectoral) }

      context 'reject internal answer' do
        let(:internal_user) { create(:user, :operator_internal) }
        let(:ticket_log) do
          create(:ticket_log, :with_final_answer, responsible: internal_user,
            resource: answer, ticket: ticket, data: data)
        end

        let(:data) { { responsible_department_id: internal_user.department_id } }
        let(:ticket_department) do
          create(:ticket_department, ticket: ticket,
            department: internal_user.department, answer: :answered)
        end

        let(:ticket_department_email) { create(:ticket_department_email, ticket_department: ticket_department) }
        let(:created_ticket_department_email) { TicketDepartmentEmail.last }

        let(:notifier) { double }

        before do
          ticket_department
          ticket_log

          allow(Notifier::Referral::AdditionalUserRejected).to receive(:delay) { notifier }
          allow(notifier).to receive(:call)

          ticket_department_email

          service.call
        end

        it 'update answer_status' do

          expect(answer.reload.sectoral_rejected?).to be_truthy
        end

        it 'ticket status' do
          expect(ticket.reload.internal_attendance?).to be_truthy
        end

        it 'changes ticket_department to not_answered ' do
          expect(ticket_department.reload).to be_not_answered
        end

        it 'notify additional users' do
          expect(notifier).to have_received(:call).with(ticket.id, created_ticket_department_email.id, user.id, justification)
        end

        it 'identify who reject answer' do
          ticket_log.reload
          expect(ticket_log.data[:responsible_user_evaluated_answer_id]).to eq(user.id)
        end
      end

      context 'reject subnet answer' do
        let(:subnet_user) { create(:user, :operator_subnet, organ: ticket.organ, subnet: ticket.subnet) }
        let(:answer) { create(:answer, answer_scope: :subnet, ticket: ticket) }
        let(:ticket) { create(:ticket, :with_parent, :with_subnet) }
        let(:ticket_log) do
          create(:ticket_log, :with_final_answer, responsible: subnet_user,
            resource: answer, ticket: ticket, data: data)
        end

        let(:data) do
          {
            responsible_subnet_id: subnet_user.subnet_id
          }
        end

        let(:ticket_department) do
          create(:ticket_department, ticket: ticket, answer: :answered)
        end

        before do
          ticket_department
          ticket_log


          service.call
        end

        it 'update answer_status' do

          expect(answer.reload.sectoral_rejected?).to be_truthy
        end

        it 'ticket status' do
          expect(ticket.reload.subnet_attendance?).to be_truthy
        end

        it 'changes ticket_department to not_answered ' do
          expect(ticket_department.reload).to be_not_answered
        end

        it 'identify who reject answer' do
          ticket_log.reload
          expect(ticket_log.data[:responsible_user_evaluated_answer_id]).to eq(user.id)
        end
      end
    end

    context 'when operator cge' do
      let(:user) { create(:user, :operator_cge) }

      context 'reject sectoral answer' do

        before do
          create_list(:ticket_department, 2, answer: :answered,
            ticket: ticket)

          service.call

          answer.reload
          ticket.reload
        end

        it 'update answer_status' do
          expect(answer.cge_rejected?).to be_truthy
        end

        it 'ticket status' do
          expect(ticket.sectoral_attendance?).to be_truthy
          expect(ticket.parent.sectoral_attendance?).to be_truthy
        end

        it 'ticket department' do
          expect(ticket.ticket_departments.exists?(answer: :answered)).to be_falsey
        end
      end

      context 'ticket status' do
        context 'when ticket has not partial_answer' do
          before { service.call }

          it { expect(ticket.reload.internal_status).to eq('sectoral_attendance') }
          it { expect(ticket.parent.reload).to be_sectoral_attendance }
        end

        context 'when ticket has partial_answer' do
          let!(:partial_answer) { create(:answer, :partial, ticket: ticket, status: answer_status) }

          before do
            service.call

            ticket.reload
          end

          context 'rejected' do
            let(:answer_status) { :cge_rejected }

            it { expect(ticket).to be_sectoral_attendance }
          end

          context 'approved' do
            let(:answer_status) { :cge_approved }

            it { expect(ticket).to be_partial_answer }
          end

          context 'only in previous version and ticket is reopened' do
            let(:ticket) { create(:ticket, :with_reopen) }
            let(:answer) { create(:answer, ticket: ticket, version: ticket.reopened) }
            let!(:partial_answer) { create(:answer, :partial, ticket: ticket, status: :cge_approved, version: 0) }

            before do
              service.call

              ticket.reload
            end

            it { expect(ticket).to be_sectoral_attendance }
          end
        end
      end

      context 'reject subnet answer' do
        let(:subnet_user) { create(:user, :operator_subnet, organ: ticket.organ, subnet: ticket.subnet) }
        let(:answer) { create(:answer, answer_scope: :subnet, ticket: ticket, status: :awaiting) }
        let(:ticket) { create(:ticket, :with_parent, :with_subnet) }
        let(:ticket_log) do
          create(:ticket_log, :with_final_answer, responsible: subnet_user,
            resource: answer, ticket: ticket, data: data)
        end

        let(:data) do
          {
            responsible_subnet_id: subnet_user.subnet_id
          }
        end

        let(:ticket_department) do
          create(:ticket_department, ticket: ticket, answer: :answered)
        end

        before do
          ticket_department
          ticket_log

          service.call
        end

        it 'update answer_status' do

          expect(answer.reload.cge_rejected?).to be_truthy
        end

        it 'ticket status' do
          expect(ticket.reload.subnet_attendance?).to be_truthy
        end

        it 'changes ticket_department to not_answered ' do
          expect(ticket_department.reload).to be_not_answered
        end

        it 'identify who reject answer' do
          ticket_log.reload
          expect(ticket_log.data[:responsible_user_evaluated_answer_id]).to eq(user.id)
        end
      end
    end

    context 'ticket_logs' do
      let(:data_attributes) { { acronym: ticket.organ_acronym, responsible_as_author: user.as_author } }

      it 'cge_rejected' do
        allow(RegisterTicketLog).to receive(:call)

        service.call

        expect(RegisterTicketLog).to have_received(:call).with(parent, user, :answer_cge_rejected, resource: answer, data: data_attributes)
      end

      it 'cge updated' do
        answer.update_column(:description, 'other description')

        allow(RegisterTicketLog).to receive(:call)

        service.call

        expect(RegisterTicketLog).to have_received(:call).with(parent, user, :answer_updated, resource: answer, data: data_attributes)
      end
    end

    context 'notify' do
      let(:notifier) { double }

      before do
        allow(Notifier::Answer).to receive(:delay) { notifier }
        allow(notifier).to receive(:call)

        service.call
      end

      it { expect(notifier).to have_received(:call).with(answer.id, user.id) }
    end

  end
end
