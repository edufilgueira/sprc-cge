require 'rails_helper'

describe Answer::ApprovalService do
    let(:service) { Answer::ApprovalService.new(answer, user, justification) }
    let(:answer) { create(:answer, :child_ticket) }
    let(:ticket) { answer.ticket }
    let(:parent) { ticket.parent }
    let(:justification) { 'Lorem' }
    let(:user) { create(:user, :operator_cge) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      justification_service = double

      allow(Answer::ApprovalService).to receive(:new) { justification_service }
      allow(justification_service).to receive(:call)

      Answer::ApprovalService.call(answer, user, justification)

      expect(Answer::ApprovalService).to have_received(:new).with(answer, user, justification)
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
    it 'responds to creator' do
      expect(service.user).to eq(user)
    end

  end

  describe 'call' do

    context 'cge answer_status' do
      before do
        service.call

        answer.reload
      end

      it { expect(answer.cge_approved?).to be_truthy }
    end

    context 'coordination answer_status' do
      let(:user) { create(:user, :operator_coordination) }
      before do
        service.call

        answer.reload
      end

      it { expect(answer.cge_approved?).to be_truthy }
    end

    context 'sectoral answer_status' do
      let(:user) { create(:user, :operator_sectoral) }
      before do
        service.call

        answer.reload
      end

      context 'department answer' do
        it { expect(answer.sectoral_approved?).to be_truthy }
      end

      context 'subnet answer' do
        let(:subnet_user) { create(:user, :operator_subnet, organ: ticket.organ, subnet: ticket.subnet) }
        let(:answer) { create(:answer, answer_scope: :subnet, ticket: ticket) }
        let(:ticket) { create(:ticket, :with_parent, :with_subnet) }

        it { expect(answer.cge_approved?).to be_truthy }

        context 'with organ.ignore_cge_validation = true' do
          let(:organ) { create(:executive_organ, ignore_cge_validation: true) }
          let(:ticket) { create(:ticket, :with_parent, :with_subnet, organ: organ, subnet: organ.subnet) }

          it { expect(answer.cge_approved?).to be_truthy }
        end
      end
    end

    context 'subnet answer_status' do
      let(:user) { create(:user, :operator_subnet, organ: ticket.organ, subnet: ticket.subnet) }
      let(:ticket) { create(:ticket, :with_parent, :with_subnet) }
      let(:ticket_log) do
        create(:ticket_log, :with_final_answer,resource: answer, ticket: ticket, data: {})
      end

      before do
        ticket_log
        service.call

        answer.reload
      end

      it { expect(answer.subnet_approved?).to be_truthy }

      it 'identify who reject answer' do
        ticket_log.reload
        expect(ticket_log.data[:responsible_user_evaluated_answer_id]).to eq(user.id)
      end
    end

    context 'ticket status' do

      context 'when answer partial' do
        before { answer.partial! }

        it 'change to partial_answer' do
          current_datetime = DateTime.now

          allow(DateTime).to receive(:now){ current_datetime }

          service.call

          ticket.reload
          parent.reload

          expect(ticket).to be_partial_answer
          expect(ticket.responded_at.utc.to_i).to eq(current_datetime.utc.to_i)

          expect(parent).to be_partial_answer
          expect(parent.responded_at.utc.to_i).to eq(current_datetime.utc.to_i)
        end

        it 'does not change to waiting_allocation when anwer_type phone' do
          parent.answer_phone = "(11) 91111-1111"
          parent.phone!

          service.call
          parent.reload

          expect(parent.call_center_status).to eq(nil)
        end
      end

      context 'when answer final' do
        it 'change to final_answer' do
          current_datetime = DateTime.now

          allow(DateTime).to receive(:now){ current_datetime }

          service.call

          ticket.reload
          parent.reload

          expect(ticket.final_answer?).to be_truthy
          expect(ticket.responded_at.utc.to_i).to eq(current_datetime.utc.to_i)

          expect(parent.final_answer?).to be_truthy
          expect(parent.responded_at.utc.to_i).to eq(current_datetime.utc.to_i)
        end
        it 'and other organ partial answer' do
          other_ticket = create(:ticket, :with_parent, parent: parent, internal_status: :partial_answer)
          current_datetime = DateTime.now

          allow(DateTime).to receive(:now){ current_datetime }

          service.call

          ticket.reload
          parent.reload

          expect(ticket.final_answer?).to be_truthy
          expect(ticket.responded_at.utc.to_i).to eq(current_datetime.utc.to_i)

          expect(other_ticket.partial_answer?).to be_truthy

          expect(parent.partial_answer?).to be_truthy
          expect(parent.responded_at.utc.to_i).to eq(current_datetime.utc.to_i)
        end

        it 'change to waiting_allocation when anwer_type phone' do
          parent.answer_phone = "(11) 91111-1111"
          parent.phone!

          service.call
          parent.reload

          expect(parent).to be_waiting_allocation
        end
      end

      it 'parent internal_status to sectoral_attendance when parent has more than 1 child' do
        second_child = create(:ticket, :confirmed, :with_organ, parent: parent, internal_status: :sectoral_attendance)
        parent.cge_validation!

        service.call

        ticket.reload
        parent.reload
        second_child.reload

        expect(parent.sectoral_attendance?).to be_truthy
        expect(ticket.final_answer?).to be_truthy
        expect(second_child.sectoral_attendance?).to be_truthy
      end

      it 'parent internal_status to sectoral_attendance when parent has 1 child in validation' do
        second_child = create(:ticket, :confirmed, :with_organ, parent: parent, internal_status: :cge_validation)
        parent.cge_validation!

        service.call

        ticket.reload
        parent.reload
        second_child.reload

        expect(parent.cge_validation?).to be_truthy
        expect(ticket.final_answer?).to be_truthy
        expect(second_child.cge_validation?).to be_truthy
      end

      context 'for subnet answer' do
        let(:subnet_user) { create(:user, :operator_subnet) }
        let(:subnet) { subnet_user.subnet }
        let(:organ) { subnet_user.organ }
        let(:ticket) { create(:ticket, :with_parent, :with_subnet, subnet: subnet, organ: subnet.organ) }

        let(:answer) { create(:answer, answer_scope: :subnet, ticket: ticket) }

        context 'sectoral user' do
          let(:user) { create(:user, :operator_sectoral) }

          it 'final_answer' do
            service.call

            ticket.reload
            parent.reload
            answer.reload

            expect(ticket.final_answer?).to be_truthy
            expect(answer.cge_approved?).to be_truthy
            expect(parent.final_answer?).to be_truthy
          end

          context 'when organ_ignore_cge_validation' do
            let(:organ) { create(:executive_organ, ignore_cge_validation: true) }

             it 'parent internal_status to sectoral_attendance when parent has more than 1 child' do
              second_child = create(:ticket, :confirmed, :with_organ, parent: parent, internal_status: :sectoral_attendance)
              parent.cge_validation!

              service.call

              ticket.reload
              parent.reload
              second_child.reload

              expect(parent.sectoral_attendance?).to be_truthy
              expect(ticket.final_answer?).to be_truthy
              expect(second_child.sectoral_attendance?).to be_truthy
            end

            it 'parent internal_status to sectoral_attendance when parent has 1 child in validation' do
              second_child = create(:ticket, :confirmed, :with_organ, parent: parent, internal_status: :cge_validation)
              parent.cge_validation!

              service.call

              ticket.reload
              parent.reload
              second_child.reload

              expect(parent.cge_validation?).to be_truthy
              expect(ticket.final_answer?).to be_truthy
              expect(second_child.cge_validation?).to be_truthy
            end
          end
        end
      end
    end

    context 'ticket_logs' do
      let(:data_attributes) { { acronym: ticket.organ_acronym, responsible_as_author: user.as_author } }

      it 'cge_approved' do
        allow(RegisterTicketLog).to receive(:call)

        service.call

        expect(RegisterTicketLog).to have_received(:call).with(parent, user, :answer_cge_approved, resource: answer, data: data_attributes)
      end

      it 'cge updated' do
        answer.update_column(:description, 'other description')

        allow(RegisterTicketLog).to receive(:call)

        service.call

        expect(RegisterTicketLog).to have_received(:call).with(parent, user, :answer_updated, resource: answer, data: data_attributes)
      end
    end

    context 'set answer.deadline = ticket.deadline' do
      before do
        ticket.update(deadline: 5)

        service.call

        answer.reload
      end

      it { expect(answer.deadline).to eq(ticket.deadline) }
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
