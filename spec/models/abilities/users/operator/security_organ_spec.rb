require 'rails_helper'
require 'cancan/matchers'

describe Abilities::Users::Operator::SecurityOrgan do

  let(:organ) { create(:executive_organ) }
  let(:department) { create(:department, organ: organ) }
  let(:other_department) { create(:department, organ: organ) }
  let(:user) { create(:user, :operator_security_organ, department: department, organ: organ) }

  subject(:ability) { Abilities::Users::Operator::SecurityOrgan.new(user) }

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
    let(:other_operator) { create(:user, :operator_security_organ, department: department, organ: organ) }

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

    let(:ticket) { create(:ticket, :with_parent, :in_internal_attendance, organ: organ) }
    let(:ticket_department) { create(:ticket_department, ticket: ticket, department: department) }
    let(:parent) { ticket.parent }

    let(:finalized_ticket) { create(:ticket, :with_parent, :in_internal_attendance, organ: organ) }
    let(:finalized_ticket_department) { create(:ticket_department, ticket: finalized_ticket, department: department) }

    let(:ticket_from_other_department) { create(:ticket, :with_parent, :confirmed, organ: organ) }
    let(:other_department) { create(:department, organ: organ) }
    let(:other_ticket_department) { create(:ticket_department, ticket: ticket, department: other_department) }

    let(:ticket_created_by_user) { create(:ticket, created_by: user) }
    let(:ticket_finalized) { create(:ticket, :with_parent, :replied, organ: organ) }

    context 'manage' do
      before { ticket_department; finalized_ticket_department }

      it { is_expected.to be_able_to(:create, Ticket) }
      it { is_expected.to be_able_to(:search, Ticket) }
      it { is_expected.to be_able_to(:read, Ticket.new) }

      it { is_expected.to be_able_to(:read, ticket) }
      it { is_expected.to be_able_to(:read, finalized_ticket) }
      it { is_expected.to be_able_to(:read, ticket_created_by_user) }

      it { is_expected.not_to be_able_to(:edit, Ticket) }
      it { is_expected.not_to be_able_to(:update, Ticket) }

      it { is_expected.to be_able_to(:read, Ticket) }
    end

    context 'history' do

      before do
        ticket_department
        ticket_from_other_department
      end

      it { is_expected.to be_able_to(:history, ticket) }
      it { is_expected.to be_able_to(:history, ticket.parent) }
      it { is_expected.to be_able_to(:history, ticket_created_by_user) }

      it { is_expected.not_to be_able_to(:history, ticket_from_other_department) }
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
      let(:ticket_denunciation) { create(:ticket, :denunciation)}

      it { is_expected.not_to be_able_to(:change_sou_type, Ticket) }
      it { is_expected.not_to be_able_to(:change_sou_type, ticket_denunciation) }

    end

    context 'change_answer_type_label' do
      let(:ticket) { create(:ticket) }

      it { is_expected.not_to be_able_to(:view_answer_type_label, ticket) }
    end

    context 'view answer type' do
      let(:ticket) { create(:ticket) }

      it { is_expected.not_to be_able_to(:view_answer_type, ticket) }
    end

    context 'view deadline' do
      it { is_expected.to be_able_to(:can_view_deadline, ticket) }

      context 'ticket replied' do
        let(:ticket_replied) { create(:ticket, :with_parent, :replied, organ: organ) }

        it { is_expected.not_to be_able_to(:can_view_deadline, ticket_replied) }
      end

      context 'ticket partial_answer' do
        let(:ticket_partial_answer) { create(:ticket, :with_parent, internal_status: :partial_answer, organ: organ) }

        it { is_expected.not_to be_able_to(:can_view_deadline, ticket_partial_answer) }
      end
    end

    context 'global_tickets_index' do
      it { is_expected.not_to be_able_to(:global_tickets_index, Ticket) }
    end

    context 'invalidate' do
      it { is_expected.not_to be_able_to(:invalidate, Ticket) }
    end

    context 'clone_ticket' do
      it { is_expected.not_to be_able_to(:clone_ticket, Ticket) }
    end

    context 'forward' do
      before do
        ticket_department
        other_ticket_department
      end

      it { is_expected.to be_able_to(:forward, ticket) }
      it { is_expected.not_to be_able_to(:forward, ticket_from_other_department) }
      it { is_expected.not_to be_able_to(:forward, ticket_finalized) }
      it { is_expected.not_to be_able_to(:forward, ticket_finalized.parent) }

      context 'with deadline' do
        let(:deadline) { Ticket::CGE_SHARE_DEADLINE }
        let(:created_at) { Date.today }
        let(:ticket_department) { create(:ticket_department, ticket: ticket, department: department, created_at: created_at) }

        before { allow(Holiday).to receive(:next_weekday) { deadline } }

        context '> 5' do
          let(:created_at) { Date.yesterday - deadline }

          it { is_expected.not_to be_able_to(:forward, ticket) }
        end

        context '<= 5' do
          let(:created_at) { Date.today - deadline }

          it { is_expected.to be_able_to(:forward, ticket) }
        end
      end

      context 'when already return positioning' do
        let!(:awaiting_answer) { create(:answer, :awaiting_positioning, user: user, ticket: ticket)}
        let!(:approved_answer) { create(:answer, :approved_positioning, user: user, ticket: ticket)}
        let!(:rejected_answer) { create(:answer, :rejected_positioning, user: user, ticket: ticket)}

        before { ticket_department }

        it { is_expected.not_to be_able_to(:forward, ticket) }
      end
    end

    describe '#share_internal_area' do
      context 'user department is the same of ticket department' do
        it 'be able to internal area' do
          ticket = ticket_department.ticket
          is_expected.to be_able_to(:share_internal_area, ticket)
        end
      end

      context 'user department is different from ticket department' do
        it 'not be able to internal area' do
          other_ticket_department = create(:ticket_department, ticket: ticket, department: other_department)
          is_expected.to_not be_able_to(:share_internal_area, other_ticket_department.ticket)
        end
      end

      context 'ticket is open' do
        it 'be able to internal area' do
          ticket = ticket_department.ticket
          is_expected.to be_able_to(:share_internal_area, ticket)
        end
      end

      context 'ticket is closed' do
        it 'not be able to internal area' do
          ticket = ticket_department.ticket
          ticket.internal_status = :final_answer
          is_expected.to_not be_able_to(:share_internal_area, ticket)
        end
      end

      context 'ticket is rede ouvir' do
        it 'not be able to internal area' do
          ticket = ticket_department.ticket
          ticket.rede_ouvir = true
          is_expected.to_not be_able_to(:share_internal_area, ticket)
        end
      end

      context 'ticket is not rede ouvir' do
        it 'not be able to internal area' do
          ticket = ticket_department.ticket
          ticket.save(rede_ouvir: false)
          is_expected.to be_able_to(:share_internal_area, ticket)
        end
      end
      context 'internal status is appeal' do  
      let(:appeal_ticket) { create(:ticket, :with_appeal) }     
        it 'not be able to internal area' do
          is_expected.not_to be_able_to(:share_internal_area, appeal_ticket)
        end
      end
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

    describe '#transfer_department' do
      before do
        ticket_department
        ticket_from_other_department
      end

      context 'ticket department same user department' do
        it 'not be able to internal area' do
          is_expected.to be_able_to(:transfer_department, ticket_department)
        end
      end

      context 'ticket department different from user department' do
        it 'not be able to internal area' do
          is_expected.not_to be_able_to(:transfer_department, ticket_from_other_department)
        end
      end

      context 'ticket is closed' do
        it 'not be able to internal area' do
          is_expected.not_to be_able_to(:transfer_department, ticket_finalized.ticket_departments.first)
        end
      end
    end

    context 'appeal' do
      let(:ticket) { create(:ticket, :sic, :with_parent_sic, :replied, organ: organ) }
      let(:ticket_created_by_user) { create(:ticket, :sic, :replied, created_by: user) }

      before { ticket_department }

      it { is_expected.not_to be_able_to(:appeal, ticket) }
      it { is_expected.not_to be_able_to(:appeal, ticket_created_by_user) }
    end

    context 'reopen' do
      let(:ticket_created_by_user) { create(:ticket, :replied, created_by: user) }

      before { ticket_department }

      it { is_expected.not_to be_able_to(:reopen, ticket) }
      it { is_expected.not_to be_able_to(:reopen, ticket_created_by_user) }

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
      it { is_expected.not_to be_able_to(:view_public_comment, Ticket) }
    end

    context 'immediate_answer' do
      it { is_expected.not_to be_able_to(:immediate_answer, Ticket) }
    end

    context 'classify' do
      it { is_expected.not_to be_able_to(:classify, Ticket) }
    end

    context 'classify_without_organ' do
      it 'when ticket appeal' do
        parent_appeal = create(:ticket, :with_appeal, parent_id: nil)
        create(:ticket, :with_parent, :sic, :with_classification, :replied, parent_id: parent_appeal)

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
      before { ticket_department }

      it { is_expected.not_to be_able_to(:answer, ticket) }
      it { is_expected.not_to be_able_to(:answer, ticket_from_other_department) }

      context 'when ticket_department already answered' do
        before { ticket_department.answered! }

        it { is_expected.not_to be_able_to(:answer, ticket) }
      end
    end

    context 'view user info' do
      let(:ticket_denunciation) { create(:ticket, :denunciation) }

      before { ticket_department }

      it { is_expected.not_to be_able_to(:view_user_info, ticket) }
      it { is_expected.to be_able_to(:view_user_info, ticket_created_by_user) }
      it { is_expected.not_to be_able_to(:view_user_info, ticket_denunciation) }
    end

    context 'note' do
      it { is_expected.not_to be_able_to(:edit_note, Ticket) }
      it { is_expected.not_to be_able_to(:update_note, Ticket) }
    end

    context 'create_positioning' do
      it { is_expected.not_to be_able_to(:create_positioning, Ticket) }
    end

    context 'denunciation' do
      it { is_expected.not_to be_able_to(:view_denunciation, Ticket) }
      it { is_expected.not_to be_able_to(:edit_denunciation_organ, Ticket) }
      it { is_expected.not_to be_able_to(:classify_denunciation, Ticket) }
    end

    context 'email_reply' do
      it { is_expected.not_to be_able_to(:email_reply, Ticket) }
    end

    context 'internal evaluation SOU' do
      context 'evaluation tab available' do

        context 'sic' do
          let(:ticket_sic) { create(:ticket, :replied, :sic) }

          it { is_expected.not_to be_able_to(:can_view_ticket_attendance_evaluation, ticket_sic) }
        end

        context 'sou' do
          let(:ticket) { create(:ticket, :replied, :marked_internal_evaluation) }

          context 'Selected for Internal Evaluation' do
            it { is_expected.not_to be_able_to(:view_ticket_attendance_evaluation, ticket) }
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
    it { is_expected.not_to be_able_to(:read, Department) }
    it { is_expected.not_to be_able_to(:update, Department) }
    it { is_expected.not_to be_able_to(:destroy, Department) }

    context 'subnet department' do
      it { is_expected.not_to be_able_to(:subnet_index, Department) }
      it { is_expected.not_to be_able_to(:subnet_show, Department) }
    end
  end

  describe 'Answer' do
    it { is_expected.not_to be_able_to(:approve_answer, Answer) }
    it { is_expected.not_to be_able_to(:reject_answer, Answer) }
    it { is_expected.not_to be_able_to(:edit_answer, Answer) }
    it { is_expected.not_to be_able_to(:change_answer_certificate, Answer) }
    it { is_expected.not_to be_able_to(:evaluate, Answer) }

    context 'view' do
      let(:ticket) { create(:ticket, :with_parent, organ: organ) }
      let(:ticket_department) { create(:ticket_department, ticket: ticket, department: department) }
      let(:answer) { build(:answer, ticket: ticket) }

      context 'answer_scope' do
        context 'department' do
          let(:answer) { build(:answer, ticket: ticket, answer_scope: :department) }

          it { is_expected.not_to be_able_to(:view, answer) }

          context 'when answer belongs to department' do
            before { answer.user = user }

            it { is_expected.to be_able_to(:view, answer) }
          end
        end

        context 'not department' do
          answer_scopes = Answer.answer_scopes.except :department

          answer_scopes.keys.each do |answer_scope|
            let(:answer) { build(:answer, ticket: ticket, answer_scope: answer_scope) }

            it { is_expected.to be_able_to(:view, answer) }
          end
        end
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

    context 'Protected' do
      let(:ticket_denunciation) { create(:ticket, :denunciation) }
      let(:attachment) { create(:attachment,
        attachmentable_id: ticket_denunciation.id,
        attachmentable_type: 'Ticket' )
      }

      context 'Organ Sharing' do
        let(:ticket_protection) { TicketProtectAttachment.create(
          resource_type: "Ticket",
          resource_id: ticket_denunciation.id,
          attachment_id: attachment.id)
        }

        before do
          ticket_denunciation
          attachment
          ticket_protection
        end

        it { is_expected.not_to be_able_to(:view, attachment) }
      end

      context 'Ticket Department' do
        let(:ticket_department) { create(:ticket_department, ticket: ticket_denunciation, department: user.department) }

        let(:ticket_protection) { TicketProtectAttachment.create(
          resource_type: "TicketDepartment",
          resource_id: ticket_department.id,
          attachment_id: attachment.id)
        }

        before do
          ticket_denunciation
          attachment
          ticket_department
          ticket_protection
        end

        it {
          is_expected.not_to be_able_to(:view, attachment)
        }
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

  describe 'Operator SouEvaluationSamples' do
    it { is_expected.not_to be_able_to(:manage, Operator::SouEvaluationSample) }
  end

  describe 'Operator SouEvaluationSamples GeneratedList' do
    it { is_expected.not_to be_able_to(:manage, Operator::SouEvaluationSamples::GeneratedList) }
  end
end