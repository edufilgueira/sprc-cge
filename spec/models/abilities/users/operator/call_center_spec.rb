require 'rails_helper'
require 'cancan/matchers'

describe Abilities::Users::Operator::CallCenter do

  let(:user) { create(:user, :operator_call_center) }

  subject(:ability) { Abilities::Users::Operator::CallCenter.new(user) }

  describe 'Stats::Ticket' do
    it { is_expected.not_to be_able_to(:create, Stats::Ticket) }
  end

  describe 'TicketReport' do
    it { is_expected.not_to be_able_to(:create, TicketReport) }
  end

  describe 'GrossExport' do
    it { is_expected.not_to be_able_to(:create, GrossExport) }
    it { is_expected.not_to be_able_to(:show_protester_info, GrossExport) }
  end

  describe 'AttendanceReport' do
    it { is_expected.not_to be_able_to(:create, AttendanceReport) }
  end

  describe 'EvaluationExport' do
    it { is_expected.not_to be_able_to(:create, EvaluationExport) }
  end

  describe 'User' do
    let(:other_operator) { create(:user, :operator_call_center) }

    it { is_expected.not_to be_able_to(:new, User) }
    it { is_expected.not_to be_able_to(:create, User) }

    it { is_expected.not_to be_able_to(:show, other_operator) }
    it { is_expected.not_to be_able_to(:edit, other_operator) }
    it { is_expected.not_to be_able_to(:update, other_operator) }
    it { is_expected.not_to be_able_to(:index, other_operator) }

    context 'itself' do
      it { is_expected.to be_able_to(:show, user) }
      it { is_expected.to be_able_to(:edit, user) }
      it { is_expected.to be_able_to(:update, user) }
      it { is_expected.not_to be_able_to(:index, user) }
    end
  end

  describe 'Ticket' do

    let(:ticket) { create(:ticket, :confirmed) }

    context 'manage' do

      it { is_expected.to be_able_to(:create, Ticket) }
      it { is_expected.to be_able_to(:search, Ticket) }

      it { is_expected.to be_able_to(:new, Ticket) }
      it { is_expected.to be_able_to(:read, Ticket) }
      it { is_expected.to be_able_to(:show, Ticket) }

      it { is_expected.not_to be_able_to(:edit, Ticket) }
      it { is_expected.not_to be_able_to(:update, Ticket) }
    end

    context 'history' do
      it { is_expected.to be_able_to(:history, Ticket) }
    end

    context 'publish_ticket' do
      it { is_expected.not_to be_able_to(:publish_ticket, Ticket) }
    end

    context 'extension' do
      it { is_expected.not_to be_able_to(:extend, Ticket) }
      it { is_expected.not_to be_able_to(:cancel_extend, Ticket) }
    end

    context 'change_type' do
      it { is_expected.not_to be_able_to(:change_type, Ticket) }
    end

    context 'change_sou_type' do
      let(:ticket_denunciation) { create(:ticket, :denunciation) }

      it { is_expected.not_to be_able_to(:change_sou_type, Ticket) }
      it { is_expected.not_to be_able_to(:change_sou_type, ticket_denunciation) }

    end

    context 'change_answer_type_label' do
      let(:ticket) { create(:ticket, :denunciation) }

      it { is_expected.to be_able_to(:view_answer_type_label, ticket) }
    end

    context 'view answer type' do
      let(:ticket) { create(:ticket) }

      it { is_expected.not_to be_able_to(:view_answer_type, ticket) }
    end

    context 'view deadline' do
      it { is_expected.to be_able_to(:can_view_deadline, ticket) }

      context 'ticket replied' do
        let(:ticket_replied) { create(:ticket, :replied) }

        it { is_expected.not_to be_able_to(:can_view_deadline, ticket_replied) }
      end

      context 'ticket partial_answer' do
        let(:ticket_partial_answer) { create(:ticket, :with_parent, internal_status: :partial_answer) }

        it { is_expected.not_to be_able_to(:can_view_deadline, ticket_partial_answer) }
      end
    end

    context 'internal evaluation SOU' do
      context 'evaluation tab available' do

        context 'sic' do
          let(:ticket_sic) { create(:ticket, :replied, :sic) }

          it { is_expected.not_to be_able_to(:can_view_ticket_attendance_evaluation, ticket_sic) }
        end

        context 'sou' do
          before { user.update_attribute(:denunciation_tracking, true) }

          let(:ticket) { create(:ticket, :replied, :marked_internal_evaluation) }

          context 'Selected for Internal Evaluation' do
            it { is_expected.not_to be_able_to(:view_ticket_attendance_evaluation, ticket) }
          end

          context 'Not Selected for Internal Evaluation' do
            before { user.update_attribute(:denunciation_tracking, false) }

            it { is_expected.not_to be_able_to(:view_ticket_attendance_evaluation, ticket) }
          end
        end
      end
    end

    context 'global_tickets_index' do
      it { is_expected.to be_able_to(:global_tickets_index, Ticket) }
    end

    context 'invalidate' do
      it { is_expected.not_to be_able_to(:invalidate, Ticket) }
    end

    context 'clone_ticket' do
      it { is_expected.not_to be_able_to(:clone_ticket, Ticket) }
    end

    context 'forward' do
      it { is_expected.not_to be_able_to(:forward, Ticket) }
    end

    describe '#can_share_to_couvi_and_cosco' do
      context 'when ticket transfer/share to cosco' do
        it 'not be able' do
          is_expected.not_to be_able_to(:share_to_cosco, Ticket)
        end
      end

      context 'when ticket transfer/share to couvi' do
        it 'not be able' do
          is_expected.not_to be_able_to(:share_to_couvi, Ticket)
        end
      end
    end

    context 'share' do
      it { is_expected.not_to be_able_to(:share, Ticket) }
    end

    context 'transfer_organ' do
      it { is_expected.not_to be_able_to(:transfer_organ, Ticket) }
    end

    context 'transfer_department' do
      it { is_expected.not_to be_able_to(:transfer_department, TicketDepartment) }
    end

    context 'appeal' do
      let(:parent) { create(:ticket, :sic, :replied, :with_call_center_responsible, call_center_responsible: user) }
      let(:child) { create(:ticket, :sic, :with_parent_sic, :replied, :with_call_center_responsible, call_center_responsible: user, parent: parent) }

      it { is_expected.to be_able_to(:appeal, parent) }
      it { is_expected.not_to be_able_to(:appeal, child) }

      context 'ticket answered more than 10 days ago' do
        before { parent.responded_at = 11.days.ago.to_datetime }

        it { is_expected.not_to be_able_to(:appeal, parent) }
      end

      context 'when another appeal is in progress' do
        before do
          parent.responded_at = Date.yesterday.to_datetime
          parent.appeals_at = DateTime.now
        end

        it { is_expected.not_to be_able_to(:appeal, parent) }
      end
    end

    context 'reopen' do
      let(:ticket) { create(:ticket, :replied, :with_call_center_responsible, call_center_responsible: user) }
      let(:ticket_sic) { create(:ticket, :sic, :replied, :with_call_center_responsible, call_center_responsible: user) }
      let(:ticket_sou_reopened) { create(:ticket, :with_parent, :replied, created_by: user, reopened: 1) }
      let(:ticket_sic_reopened) { create(:ticket, :sic, :with_parent, :replied, created_by: user, reopened: 1) }

      it { is_expected.to be_able_to(:reopen, ticket) }
      it { is_expected.to be_able_to(:reopen, ticket_sic) }
      it { is_expected.not_to be_able_to(:reopen, ticket_sou_reopened) }
      it { is_expected.to be_able_to(:reopen, ticket_sic_reopened) }

      context 'ticket child' do
        let(:child) { create(:ticket, :with_parent, :replied, :with_call_center_responsible, call_center_responsible: user) }
        let(:child_sic) { create(:ticket, :sic, :with_parent, :replied, :with_call_center_responsible, call_center_responsible: user) }
        let(:ticket_sou_reopened_child) { create(:ticket, :with_parent, :replied, created_by: user, reopened: 1, parent_id: ticket_sou_reopened.id) }
        let(:ticket_sic_reopened_child) { create(:ticket, :sic, :with_parent, :replied, created_by: user, reopened: 1, parent_id: ticket_sic_reopened.id) }

        it { is_expected.to be_able_to(:reopen, child) }
        it { is_expected.to be_able_to(:reopen, child_sic) }
        it { is_expected.not_to be_able_to(:reopen, ticket_sou_reopened_child) }
        it { is_expected.to be_able_to(:reopen, ticket_sic_reopened_child) }
      end

      context 'CallCenter reopen multiple times' do
        it 'final answer and reopen' do
          (1..10).each do |ticket|
            ticket_sic_reopened.confirmed!
            ticket_sic_reopened.waiting_referral!
            is_expected.not_to be_able_to(:reopen, ticket_sic_reopened)
            ticket_sic_reopened.final_answer!
            create(:answer, ticket_id: ticket_sic_reopened.id)
            is_expected.to be_able_to(:reopen, ticket_sic_reopened)
          end
        end
      end

      context 'when the ticket has already been reopened' do
        before do
          ticket.responded_at = Date.yesterday.to_datetime
          ticket.reopened_at = DateTime.now
        end

        it { is_expected.not_to be_able_to(:reopen, ticket) }
      end

      context 'with immediate_answer' do
        it 'is true' do
          ticket = create(:ticket)
          attendance = create(:attendance, :no_characteristic, ticket_id: ticket.id)

          ticket.immediate_answer = true
          ticket.save
          
          is_expected.not_to be_able_to(:reopen_ticket_with_immediate_answer, ticket)
        end

        it 'is false' do
          ticket = create(:ticket)
          attendance = create(:attendance, :no_characteristic, ticket_id: ticket.id)

          ticket.immediate_answer = false
          ticket.save
          
          is_expected.to be_able_to(:reopen_ticket_with_immediate_answer, ticket)
        end
      end
    end

    context 'attendance_evaluate' do
      it { is_expected.not_to be_able_to(:attendance_evaluate, Ticket) }
    end

    context 'public_comment' do
      it { is_expected.not_to be_able_to(:create_public_comment, Ticket) }
      it { is_expected.to be_able_to(:view_public_comment, Ticket) }
    end

    context 'immediate_answer' do
      it { is_expected.not_to be_able_to(:immediate_answer, Ticket) }
    end

    context 'classify' do
      it { is_expected.not_to be_able_to(:classify, Ticket) }
    end

    context 'classify_without_organ' do
      it { is_expected.not_to be_able_to(:classify_without_organ, Ticket) }
    end

    context 'answer' do
      it { is_expected.not_to be_able_to(:answer, Ticket) }
    end

    context 'view user info' do
      it { is_expected.to be_able_to(:view_user_info, Ticket) }
    end

    context 'view user password' do
      it { is_expected.to be_able_to(:view_user_password, Ticket) }
    end

    context 'note' do
      it { is_expected.to be_able_to(:edit_note, Ticket) }
      it { is_expected.to be_able_to(:update_note, Ticket) }
    end

    context 'create_positioning' do
      it { is_expected.not_to be_able_to(:create_positioning, Ticket) }
    end

    context 'denunciation' do
      let(:denunciation) { create(:ticket, :denunciation) }

      it { is_expected.to be_able_to(:view_denunciation, denunciation) }
      it { is_expected.not_to be_able_to(:view_denunciation, ticket) }

      it { is_expected.to be_able_to(:edit_denunciation_organ, denunciation) }
      it { is_expected.not_to be_able_to(:edit_denunciation_organ, ticket) }

      it { is_expected.not_to be_able_to(:classify_denunciation, Ticket) }
    end

    context 'email_reply' do
      let(:child_ticket) { create(:ticket, :with_parent, internal_status: :final_answer) }
      let(:parent_ticket) { child_ticket.parent }
      let!(:answer) { create(:answer, :cge_approved, ticket: child_ticket) }

      it { is_expected.to be_able_to(:email_reply, parent_ticket) }
      it { is_expected.to be_able_to(:email_reply, child_ticket) }

      context 'when answer only in parent' do
        let(:parent_ticket) { create(:ticket, :replied) }

        it { is_expected.to be_able_to(:email_reply, parent_ticket) }
      end

      context 'when answer evaluated' do
        let!(:answer) { create(:answer, :user_evaluated, ticket: parent_ticket) }

        it { is_expected.to be_able_to(:email_reply, parent_ticket) }
      end
    end

    context 'delete_share' do
      let(:child_classified) { create(:ticket, :with_parent, :with_classification, :in_sectoral_attendance) }
      let(:child_old) { create(:ticket, :with_parent, :in_sectoral_attendance, confirmed_at: 1.month.ago) }
      let(:reopened_ticket) { create(:ticket, :with_classification, :with_reopen) }
      let(:child_ticket) { create(:ticket, :with_parent, :in_sectoral_attendance) }
      let(:child_ticket_finalized) { create(:ticket, :with_parent, internal_status: :final_answer) }

      it { is_expected.to be_able_to(:delete_share, child_ticket) }
      it { is_expected.to be_able_to(:delete_share, child_classified) }
      it { is_expected.to be_able_to(:delete_share, child_old) }

      it { is_expected.not_to be_able_to(:delete_share, child_ticket_finalized) }
      it { is_expected.not_to be_able_to(:delete_share, reopened_ticket) }
    end

    context 'organ_association' do
      it { is_expected.not_to be_able_to(:view_organ_association, User) }
    end
  end

  describe 'TicketDepartment' do
    it { is_expected.not_to be_able_to(:edit, TicketDepartment) }
    it { is_expected.not_to be_able_to(:update, TicketDepartment) }
    it { is_expected.not_to be_able_to(:poke, TicketDepartment) }
  end

  describe 'Department' do
    it { is_expected.not_to be_able_to(:index, Department) }
    it { is_expected.not_to be_able_to(:create, Department) }
    it { is_expected.not_to be_able_to(:edit, Department) }
    it { is_expected.not_to be_able_to(:read, Department) }
    it { is_expected.not_to be_able_to(:update, Department) }
    it { is_expected.not_to be_able_to(:destroy, Department) }

    context 'subnet department' do
      it { is_expected.not_to be_able_to(:subnet_index, Department) }
      it { is_expected.not_to be_able_to(:subnet_show, Department) }
    end
  end

  describe 'Answer' do
    it { is_expected.to be_able_to(:view, Answer) }

    it { is_expected.not_to be_able_to(:approve_answer, Answer) }
    it { is_expected.not_to be_able_to(:reject_answer, Answer) }
    it { is_expected.not_to be_able_to(:edit_answer, Answer) }
    it { is_expected.not_to be_able_to(:change_answer_certificate, Answer) }

    context 'evaluate' do
      let(:ticket) { create(:ticket, :replied) }
      let(:answer) { create(:answer, :final, ticket: ticket) }

      it { is_expected.to be_able_to(:evaluate, answer) }

      context 'when answer.status = :user_evaluated' do
        before { answer.user_evaluated! }

        it { is_expected.not_to be_able_to(:evaluate, answer) }
      end

      context 'when answer.answer_scope = :partial' do
        before { answer.partial! }

        it { is_expected.not_to be_able_to(:evaluate, answer) }
      end

      context 'when ticket not  :final_answer' do
        before { ticket.partial_answer! }

        it { is_expected.not_to be_able_to(:evaluate, answer) }
      end
    end
  end

  describe 'AttendanceResponse' do
    it { is_expected.to be_able_to(:show, AttendanceResponse) }
    it { is_expected.to be_able_to(:create, AttendanceResponse) }
  end

  describe 'Comment' do
    it { is_expected.to be_able_to(:view, Comment) }
  end

  describe 'Attachment' do
    let(:attachment) { create(:attachment) }

    it { is_expected.to be_able_to(:view, attachment) }

    context 'destroy' do
      context 'when is not the attachment owner' do
        it { is_expected.not_to be_able_to(:destroy, attachment) }
      end

      context 'when is the attachment owner' do
        before { attachment.attachmentable.created_by = user }

        it { is_expected.to be_able_to(:destroy, attachment) }
      end
    end
  end

  describe 'AnswerTemplate' do
    let(:answer_template) { create(:answer_template, user: user) }
    let(:another_answer_template) { create(:answer_template) }

    it { is_expected.to be_able_to(:manage, answer_template) }
    it { is_expected.not_to be_able_to(:manage, another_answer_template) }
  end

  describe 'Answer type option' do
    context 'answer option with letter' do
      it { is_expected.not_to be_able_to(:answer_by_letter, user) }
    end
    context 'answer option with phone' do
      it { is_expected.to be_able_to(:answer_by_phone, user) }
    end
  end

  describe 'Operator SouEvaluationSamples' do
    it { is_expected.not_to be_able_to(:manage, Operator::SouEvaluationSample) }
  end

  describe 'Operator SouEvaluationSamples GeneratedList' do
    it { is_expected.not_to be_able_to(:manage, Operator::SouEvaluationSamples::GeneratedList) }
  end

end
