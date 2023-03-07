require 'rails_helper'
require 'cancan/matchers'

describe Abilities::Users::Operator::Cge do

  let(:user) { create(:user, :operator_cge) }

  subject(:ability) { Abilities::Users::Operator::Cge.new(user) }

  describe 'Stats::Ticket' do
    it 'started' do
      stats_ticket = build(:stats_ticket, status: :started)

      is_expected.not_to be_able_to(:create, stats_ticket)
    end

    it 'created' do
      stats_ticket = build(:stats_ticket, status: :created)

      is_expected.to be_able_to(:create, stats_ticket)
    end
  end

  describe 'TicketReport' do
    it { is_expected.to be_able_to(:create, TicketReport) }
  end

  describe 'SolvabilityReport' do
    it { is_expected.to be_able_to(:create, SolvabilityReport) }
  end

  describe 'GrossExport' do
    it { is_expected.to be_able_to(:create, GrossExport) }
    it { is_expected.to be_able_to(:show_protester_info, GrossExport) }
  end

  describe 'AttendanceReport' do
    it { is_expected.not_to be_able_to(:create, AttendanceReport) }
  end

  describe 'EvaluationExport' do
    it { is_expected.to be_able_to(:create, EvaluationExport) }
  end

  describe 'User' do
    it { is_expected.to be_able_to(:index, User) }
    it { is_expected.to be_able_to(:show, User) }

    it { is_expected.not_to be_able_to(:new, User) }
    it { is_expected.not_to be_able_to(:create, User) }

    context 'itself' do
      it { is_expected.to be_able_to(:show, user) }
      it { is_expected.to be_able_to(:edit, user) }
      it { is_expected.to be_able_to(:update, user) }
    end

    context 'other users' do
      let(:other) { create(:user, :operator_cge) }

      it { is_expected.not_to be_able_to(:edit, other) }
      it { is_expected.not_to be_able_to(:update, other) }
    end
  end

  describe 'Ticket' do
    let(:ticket) { create(:ticket, :confirmed) }
    let(:child_ticket) { create(:ticket, :with_parent, parent: ticket) }

    let(:ticket_denunciation) { create(:ticket, :denunciation) }

    context 'manage' do

      it { is_expected.to be_able_to(:create, Ticket) }
      it { is_expected.to be_able_to(:search, Ticket) }

      it { is_expected.to be_able_to(:read, ticket) }
      it { is_expected.not_to be_able_to(:read, ticket_denunciation) }

      it { is_expected.not_to be_able_to(:edit, Ticket) }
      it { is_expected.not_to be_able_to(:update, Ticket) }

      context 'when denunciation_tracking is true' do
        before { user.update_attribute(:denunciation_tracking, true) }

        it { is_expected.to be_able_to(:read, ticket_denunciation) }
      end

      context 'when created_by = user' do
        before { ticket_denunciation.update_attribute(:created_by, user) }
        it { is_expected.to be_able_to(:read, ticket_denunciation) }
      end
    end

    context 'history' do
      it { is_expected.to be_able_to(:history, ticket) }
      it { is_expected.not_to be_able_to(:history, ticket_denunciation) }

      context 'when denunciation_tracking is true' do
        before { user.update_attribute(:denunciation_tracking, true) }

        it { is_expected.to be_able_to(:history, ticket_denunciation) }
      end

      context 'when created_by = user' do
        before { ticket_denunciation.update_attribute(:created_by, user) }
        it { is_expected.not_to be_able_to(:history, ticket_denunciation) }
      end
    end

    context 'publish_ticket' do
      it { is_expected.not_to be_able_to(:publish_ticket, Ticket) }
    end

    context 'extension' do
      it { is_expected.not_to be_able_to(:extend, Ticket) }
      it { is_expected.not_to be_able_to(:cancel_extend, Ticket) }
      it { is_expected.not_to be_able_to(:approve_extension, Ticket) }
      it { is_expected.not_to be_able_to(:reject_extension, Ticket) }
    end

    context 'change_type' do
      let(:ticket_anonymous) { create(:ticket, :anonymous) }

      it { is_expected.to be_able_to(:change_type, ticket) }
      it { is_expected.to be_able_to(:change_type, child_ticket) }

      it { is_expected.not_to be_able_to(:change_type, ticket_anonymous) }

      context 'when denunciation_tracking == true' do
        before { user.denunciation_tracking = true }

        it { is_expected.to be_able_to(:change_type, ticket_denunciation) }
      end
    end
    
    context 'change_sou_type' do
      
      it { is_expected.to be_able_to(:change_sou_type, ticket) }
      it { is_expected.not_to be_able_to(:change_sou_type, ticket_denunciation) }
      
      context 'when denunciation_tracking == true' do
        before { user.denunciation_tracking = true }
        
        it { is_expected.to be_able_to(:change_sou_type, ticket_denunciation) }
      end
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
        let(:replied_ticket) { create(:ticket, :replied) }

        it { is_expected.not_to be_able_to(:can_view_deadline, replied_ticket) }
      end

      context 'ticket partial_answer' do
        let(:ticket_partial_answer) { create(:ticket, internal_status: :partial_answer) }

        it { is_expected.not_to be_able_to(:can_view_deadline, ticket_partial_answer) }
      end
    end

    context 'global_tickets_index' do
      it { is_expected.to be_able_to(:global_tickets_index, Ticket) }
    end

    context 'invalidate' do
      it { is_expected.to be_able_to(:invalidate, ticket) }
      it { is_expected.not_to be_able_to(:invalidate, child_ticket) }

      context 'approve and reject invalidation' do
        it 'waiting' do
          data_waiting = { status: :waiting }
          create(:ticket_log, ticket: child_ticket, responsible: child_ticket.organ, data: data_waiting)

          is_expected.to be_able_to(:approve_invalidation, child_ticket)
          is_expected.to be_able_to(:reject_invalidation, child_ticket)
        end

        it 'one child already approved' do
          data_approved = { status: :approved }
          create(:ticket_log, action: :invalidate, ticket: child_ticket, responsible: child_ticket.organ, data: data_approved)

          is_expected.not_to be_able_to(:approve_invalidation, child_ticket)
          is_expected.not_to be_able_to(:reject_invalidation, child_ticket)
        end
      end
    end

    context 'clone_ticket' do
      it { is_expected.to be_able_to(:clone_ticket, ticket) }
      it { is_expected.not_to be_able_to(:clone_ticket, child_ticket) }
    end

    context 'forward' do
      it { is_expected.not_to be_able_to(:forward, Ticket) }
    end

    describe '#can_share_to_couvi_and_cosco' do
      context 'when ticket transfer/share to cosco' do
        it 'be able' do
          is_expected.to be_able_to(:share_to_cosco, Ticket)
        end
      end

      context 'when ticket transfer/share to couvi' do
        it 'be able' do
          is_expected.to be_able_to(:share_to_couvi, Ticket)
        end
      end
    end

    context 'share' do
      let(:child_ticket) { create(:ticket, :with_parent, :in_sectoral_attendance) }
      let(:ticket_finalized) { create(:ticket, internal_status: :final_answer) }
      let(:child_ticket_finalized) { create(:ticket, :with_parent, internal_status: :final_answer) }
      let(:old_ticket) { create(:ticket, :confirmed, confirmed_at: 1.month.ago) }

      it { is_expected.to be_able_to(:share, ticket) }
      it { is_expected.to be_able_to(:share, old_ticket) }

      it { is_expected.not_to be_able_to(:share, child_ticket) }
      it { is_expected.not_to be_able_to(:share, ticket_finalized) }

      it 'partial_answer' do
        ticket.partial_answer!
        is_expected.not_to be_able_to(:share, ticket)
      end

      context 'denunciation ticket' do
        before { user.denunciation_tracking = true }

        context 'when denunciation type is defined' do
          it { is_expected.to be_able_to(:share, ticket_denunciation) }
        end

        context 'when denunciation type is undefined' do
          before { ticket_denunciation.denunciation_type = nil }

          it { is_expected.not_to be_able_to(:share, ticket_denunciation) }
        end
      end

      context 'reopened ticket without a organ' do
        it 'not be able to share' do
          ticket = create(:ticket, :reopened_without_organ)
          is_expected.not_to be_able_to(:share, ticket)
        end
      end

      context 'delete_share' do
        let(:child_classified) { create(:ticket, :with_parent, :with_classification, :in_sectoral_attendance) }
        let(:child_old) { create(:ticket, :with_parent, :in_sectoral_attendance, confirmed_at: 1.month.ago) }
        let(:reopened_ticket) { create(:ticket, :with_classification, :with_reopen) }

        it { is_expected.to be_able_to(:delete_share, child_ticket) }
        it { is_expected.to be_able_to(:delete_share, child_classified) }
        it { is_expected.to be_able_to(:delete_share, child_old) }

        it { is_expected.not_to be_able_to(:delete_share, child_ticket_finalized) }
        it { is_expected.not_to be_able_to(:delete_share, reopened_ticket) }
      end

      context 'after 5 days' do
        let(:new_ticket) do
          parent = child_ticket.parent
          date = (parent.created_at.to_date - 4).to_datetime
          parent.update_column(:confirmed_at, date)
          parent
        end

        let(:old_ticket) do
          parent = child_ticket.parent
          date = (parent.created_at.to_date - 7).to_datetime
          parent.update_column(:confirmed_at, date)
          parent
        end

        it { is_expected.to be_able_to(:share, new_ticket) }
        it { is_expected.to be_able_to(:share, old_ticket) }
      end
    end

    context 'transfer_organ' do
      let(:invalidated_child_ticket) { create(:ticket, :with_parent, :invalidated) }

      it { is_expected.to be_able_to(:transfer_organ, child_ticket) }

      it { is_expected.not_to be_able_to(:transfer_organ, ticket) }
      it { is_expected.not_to be_able_to(:transfer_organ, invalidated_child_ticket) }


      context 'denunciation ticket' do
        before { user.denunciation_tracking = true }
        let(:ticket_denunciation_child) { create(:ticket, :with_parent, :denunciation, parent: ticket_denunciation) }

        context 'when denunciation type is defined' do
          it { is_expected.to be_able_to(:transfer_organ, ticket_denunciation_child) }
        end

        context 'when denunciation type is undefined' do
          before { ticket_denunciation_child.denunciation_type = nil }

          it { is_expected.not_to be_able_to(:transfer_organ, ticket_denunciation_child) }
        end
      end

      context 'when the ticket has a answer' do
        it 'cant transfer to other organ' do
          ticket_child = create(:ticket, :with_parent, :with_classification)
          create(:answer, :cge_approved, version: 1, ticket_id: ticket_child.id)
          is_expected.not_to be_able_to(:transfer_organ, ticket_child)
        end
      end

      context 'when the ticket hasnt a answer' do
        it 'can transfer to other organ' do
          ticket_child = create(:ticket, :with_parent, :with_classification)
          is_expected.to be_able_to(:transfer_organ, ticket_child)
        end
      end
    end

    context 'transfer_department' do
      it { is_expected.not_to be_able_to(:transfer_department, TicketDepartment) }
    end

    context 'appeal' do
      let(:appeal_ticket) { create(:ticket, :sic, :replied )}

      it { is_expected.to be_able_to(:appeal, appeal_ticket) }
    end

    context 'reopen' do
      let(:reopen_ticket) { create(:ticket, :replied) }
      let(:reopen_sic) { create(:ticket, :sic, :replied) }
      let(:ticket_sou_reopened) { create(:ticket, :with_parent, :replied, created_by: user, reopened: 1) }
      let(:ticket_sic_reopened) { create(:ticket, :sic, :with_parent, :replied, created_by: user, reopened: 1) }

      it { is_expected.not_to be_able_to(:reopen, ticket_sou_reopened) }
      it { is_expected.to be_able_to(:reopen, ticket_sic_reopened) }
      it { is_expected.to be_able_to(:reopen, reopen_ticket) }
      it { is_expected.to be_able_to(:reopen, reopen_sic) }

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
      let(:ticket_with_children) { create(:ticket, :with_parent).parent }

      it { is_expected.to be_able_to(:attendance_evaluate, ticket) }
      it { is_expected.to be_able_to(:attendance_evaluate, child_ticket) }
      it { is_expected.not_to be_able_to(:attendance_evaluate, ticket_with_children) }
    end

    context 'public_comment' do
      it { is_expected.to be_able_to(:create_public_comment, Ticket) }
      it { is_expected.to be_able_to(:view_public_comment, Ticket) }
    end

    context 'immediate_answer' do
      it { is_expected.to be_able_to(:immediate_answer, Ticket) }
    end

    context 'classify' do
      context 'ticket parent' do
        context 'without children' do
          it { is_expected.to be_able_to(:classify, ticket) }
        end

        context 'with children' do
          let(:ticket) { create(:ticket, :with_parent).parent }

          it { is_expected.not_to be_able_to(:classify, ticket) }
        end

        context 'with children inactive' do
          let(:ticket) { create(:ticket, :with_parent, :replied).parent }

          it { is_expected.to be_able_to(:classify, ticket) }
        end

        context 'rede_ouvir' do
          before { ticket.update(rede_ouvir: true) }

          it { is_expected.not_to be_able_to(:classify, ticket) }
        end
      end

      context 'child' do
        it { is_expected.to be_able_to(:classify, child_ticket) }
      end

      context 'rede_ouvir' do
        before { child_ticket.update(rede_ouvir: true) }

        it { is_expected.not_to be_able_to(:classify, child_ticket) }
      end
    end

    context 'classify_without_organ' do
      it { is_expected.to be_able_to(:classify_without_organ, child_ticket) }

      it 'when ticket appeal' do
        parent_appeal = create(:ticket, :with_appeal, parent_id: nil)
        create(:ticket, :sic, :with_parent_sic, :with_classification, :replied, parent_id: parent_appeal)

        is_expected.not_to be_able_to(:classify_without_organ, parent_appeal)
      end

      it 'when ticket without organ' do
        ticket_without_organ = create(:ticket, :confirmed)

        is_expected.to be_able_to(:classify_without_organ, ticket_without_organ)
      end

      it 'when ticket parent no active children' do
        ticket_finalized = create(:ticket, :with_parent, :replied)
        ticket_parent = ticket_finalized.parent

        is_expected.not_to be_able_to(:classify_without_organ, ticket_parent)
      end
    end

    context 'answer' do
      context 'without children' do

        context 'when classified' do
          before { create(:classification, ticket: ticket) }

          it { is_expected.to be_able_to(:answer, ticket) }

          context 'with ticket.internal_status' do
            context 'final_answer' do
              before { ticket.final_answer! }

              it { is_expected.not_to be_able_to(:answer, ticket) }
            end

            context 'cge_validation' do
              before { ticket.cge_validation! }

              it { is_expected.not_to be_able_to(:answer, ticket) }
            end
          end
        end

        context 'when not classified' do
          it { is_expected.not_to be_able_to(:answer, ticket) }
        end
      end

      context 'with children' do

        context 'when child classified' do
          before { create(:classification, ticket: child_ticket) }

          it { is_expected.not_to be_able_to(:answer, child_ticket) }

          context 'with answer' do
            before do
              create(:answer, :sectoral_approved, ticket: child_ticket)

              ticket.cge_validation!
            end

            it { is_expected.not_to be_able_to(:answer, ticket) }
            it { is_expected.not_to be_able_to(:answer, child_ticket) }
          end

          context 'with partial_answer' do
            before do
              ticket.partial_answer!
              child_ticket.partial_answer!
              create(:answer, :sectoral_approved, ticket: child_ticket, answer_type: :partial)
            end

            it { is_expected.to be_able_to(:answer, ticket) }
            it { is_expected.to be_able_to(:answer, child_ticket) }
          end

          context 'when ticket appealed' do
            let(:parent_appeal){ create(:ticket, :with_appeal, parent_id: nil) }
            let(:child_replied) { create(:ticket, :with_parent, :with_classification, :replied, parent_id: ticket_parent) }

            it { is_expected.to be_able_to(:answer, parent_appeal) }
          end
        end
      end
    end

    context 'view user info' do
      it { is_expected.to be_able_to(:view_user_info, ticket) }
      it { is_expected.not_to be_able_to(:view_user_info, ticket_denunciation) }

      context 'when denunciation_tracking == true' do
        before { user.denunciation_tracking = true }

        it { is_expected.to be_able_to(:view_user_info, ticket_denunciation) }
      end
    end

    context 'view user password' do
      let(:user) { create(:user, :operator_cge_denunciation_tracking) }
      let(:ticket_denunciation) { create(:ticket, :denunciation) }

      it { is_expected.to be_able_to(:view_user_password, ticket) }
      it { is_expected.to be_able_to(:view_user_password, ticket_denunciation) }
    end

    context 'note' do
      it { is_expected.to be_able_to(:edit_note, ticket) }
      it { is_expected.to be_able_to(:update_note, ticket) }
    end

    context 'create_positioning' do
      it { is_expected.not_to be_able_to(:create_positioning, Ticket) }
    end

    context 'denunciation' do
      it { is_expected.not_to be_able_to(:view_denunciation, ticket_denunciation) }
      it { is_expected.not_to be_able_to(:edit_denunciation_organ, ticket_denunciation) }
      it { is_expected.not_to be_able_to(:classify_denunciation, ticket) }
      it { is_expected.not_to be_able_to(:classify_denunciation, ticket_denunciation) }

      context 'when denunciation_tracking == true' do
        before { user.denunciation_tracking = true }

        it { is_expected.to be_able_to(:view_denunciation, ticket_denunciation) }
        it { is_expected.to be_able_to(:edit_denunciation_organ, ticket_denunciation) }
        it { is_expected.to be_able_to(:classify_denunciation, ticket_denunciation) }
        it { is_expected.not_to be_able_to(:classify_denunciation, ticket) }

        context 'ticket child' do
          let!(:ticket_denunciation_child) { create(:ticket, :with_parent, :denunciation, parent: ticket_denunciation) }

          it { is_expected.to be_able_to(:view_denunciation, ticket_denunciation_child) }
          it { is_expected.not_to be_able_to(:classify_denunciation, ticket_denunciation_child) }
        end

        context 'when ticket denunciation_type is not defined' do
          before { ticket_denunciation.denunciation_type = nil }

          it { is_expected.not_to be_able_to(:classify_denunciation, ticket_denunciation) }
        end
      end
    end

    context 'email_reply' do
      context 'with child' do
        context 'not replied' do
          it { is_expected.not_to be_able_to(:email_reply, ticket) }
          it { is_expected.not_to be_able_to(:email_reply, child_ticket) }
        end

        context 'replied' do
          before do
            answer
            child_ticket.final_answer!
          end

          context 'when answer.status is' do
            context 'cge_approved' do
              let(:answer) { create(:answer, :cge_approved, ticket: child_ticket) }

              it { is_expected.to be_able_to(:email_reply, ticket) }
              it { is_expected.to be_able_to(:email_reply, child_ticket) }
            end

            context 'user_evaluated' do
              let(:answer) { create(:answer, :user_evaluated, ticket: child_ticket) }

              it { is_expected.to be_able_to(:email_reply, ticket) }
              it { is_expected.to be_able_to(:email_reply, child_ticket) }
            end

            context 'call_center_approved' do
              let(:answer) { create(:answer, :call_center_approved, ticket: child_ticket) }

              it { is_expected.to be_able_to(:email_reply, ticket) }
              it { is_expected.to be_able_to(:email_reply, child_ticket) }
            end
          end
        end
      end

      context 'without child' do
        context 'not replied' do
          it { is_expected.not_to be_able_to(:email_reply, ticket) }
        end

        context 'replied' do
          let(:answer) { create(:answer, :cge_approved, ticket: ticket) }

          before { answer }

          it { is_expected.to be_able_to(:email_reply, ticket) }

          context 'when answer evaluated' do
            let(:answer) { create(:answer, :user_evaluated, ticket: ticket) }

            it { is_expected.to be_able_to(:email_reply, ticket) }
          end
        end
      end
    end

    context 'internal evaluation SOU' do
      context 'evaluation tab available' do

        context 'sic' do
          let(:ticket_sic) { create(:ticket, :replied, :sic) }

          it { is_expected.not_to be_able_to(:can_view_ticket_attendance_evaluation, ticket_sic) }
        end

        context 'sou' do
          let(:ticket_sou) { create(:ticket, :replied) }

          context 'Selected for Internal Evaluation' do
            before { ticket_sou.update_attribute(:marked_internal_evaluation, true) }

            it { is_expected.to be_able_to(:view_ticket_attendance_evaluation, ticket_sou) }
          end

          context 'Not Selected for Internal Evaluation' do
            before { ticket.update_attribute(:marked_internal_evaluation, false) }

            it { is_expected.not_to be_able_to(:view_ticket_attendance_evaluation, ticket) }
          end
        end
      end
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
    it { is_expected.not_to be_able_to(:update, Department) }
    it { is_expected.not_to be_able_to(:destroy, Department) }

    context 'subnet department' do
      it { is_expected.not_to be_able_to(:subnet_index, Department) }
      it { is_expected.not_to be_able_to(:subnet_show, Department) }
    end
  end

  describe 'Answer' do
    let(:ticket) { create(:ticket) }
    let(:child_ticket) { create(:ticket, :with_parent, parent: ticket) }

    let(:ticket_denunciation) { create(:ticket, :denunciation) }

    let(:answer) { build(:answer, ticket: ticket) }


    context 'manage' do
      it { is_expected.to be_able_to(:view, answer) }

      context 'when not awaiting' do
        it { is_expected.to_not be_able_to(:approve_answer, answer) }
        it { is_expected.to_not be_able_to(:reject_answer, answer) }
        it { is_expected.to_not be_able_to(:edit_answer, answer) }
      end

      context 'when awaiting from sectoral' do
        before do
          answer.status = :awaiting
          answer.answer_scope = :sectoral
        end

        it { is_expected.to be_able_to(:approve_answer, answer) }
        it { is_expected.to be_able_to(:reject_answer, answer) }
        it { is_expected.to be_able_to(:edit_answer, answer) }
      end
    end

    context 'evaluate' do
      it { is_expected.not_to be_able_to(:evaluate, Answer) }
    end

    context 'change_answer_certificate' do
      let(:answer) { create(:answer, :with_certificate, ticket: ticket) }

      context 'sou' do
        let(:ticket) { create(:ticket) }

        it { is_expected.not_to be_able_to(:change_answer_certificate, answer) }
      end

      context 'sic' do
        let(:ticket) { create(:ticket, :sic) }

        it { is_expected.not_to be_able_to(:change_answer_certificate, answer) }
      end
    end
  end

  describe 'AttendanceResponse' do
    it { is_expected.to be_able_to(:show, AttendanceResponse) }
    it { is_expected.not_to be_able_to(:create, AttendanceResponse) }
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
      it { is_expected.to be_able_to(:answer_by_letter, user) }
    end
    context 'answer option with phone' do
      it { is_expected.to be_able_to(:answer_by_phone, user) }
    end
  end

  describe 'Filter by organ on reports' do
    it { is_expected.to be_able_to(:filter_by_organs_on_reports, Organ) }
  end

  context 'Certificate Negative' do
    context 'when ticket SOU' do
        let(:ticket) { create(:ticket, appeals: true) }
        it { is_expected.not_to be_able_to(:can_certificate, ticket) }
    end

    context 'when ticket SIC' do

      context 'when not appealed' do
        context 'ticket parent' do
          let(:ticket_parent) { create(:ticket, :sic, parent_id: nil)}
          it { is_expected.to be_able_to(:can_certificate, ticket_parent)}
        end

        context 'ticket children' do
          let(:ticket) { create(:ticket, :sic, :with_parent_sic, :in_sectoral_attendance) }
          it { is_expected.to be_able_to(:can_certificate, ticket) }
        end
      end

      context 'when appealed' do
        context 'ticket parent' do
          let(:ticket_parent){ create(:ticket, :with_appeal, parent_id: nil) }
          it { is_expected.not_to be_able_to(:can_certificate, ticket_parent) }
        end

        context 'ticket children' do
          let(:ticket) { create(:ticket, :sic, :with_parent_sic, :in_sectoral_attendance, :with_appeal, :with_classification) }
          it { is_expected.not_to be_able_to(:can_certificate, ticket) }
        end
      end
    end
  end

  describe 'User can restrict attachment for share with organ on denunciation ticket' do
    context 'denunciation_tracking true and user_type: operator' do
      let(:denunciation) { create(:ticket, :denunciation) }

      before { user.denunciation_tracking = true }
      it 'operator_type: cge' do
        # Triagem CGE - Denúncia

        is_expected.to be_able_to(:protect_attachment_on_share_with_organ, denunciation)
        is_expected.not_to be_able_to(:protect_attachment_on_share_with_organ, Ticket.new)
      end
    end
  end

  describe 'Operator SouEvaluationSamples' do
    it { is_expected.to be_able_to(:manage, Operator::SouEvaluationSample) }
  end

  describe 'Operator SouEvaluationSamples GeneratedList' do
    it { is_expected.to be_able_to(:manage, Operator::SouEvaluationSamples::GeneratedList) }
  end
end