require 'rails_helper'
require 'cancan/matchers'

describe Abilities::Users::Operator::SubnetChief do

  let(:organ) { create(:executive_organ) }
  let(:subnet) { create(:subnet, organ: organ) }
  let(:user) { create(:user, :operator_subnet_chief, organ: organ, subnet: subnet) }
  let(:ticket_denunciation) { create(:ticket, :denunciation) }

  subject(:ability) { Abilities::Users::Operator::SubnetChief.new(user) }

  it { is_expected.to be_able_to(:read, :all) }
  it { is_expected.to be_able_to(:index, :all) }

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

  describe 'GrossExport' do
    it { is_expected.to be_able_to(:create, GrossExport) }
    it { is_expected.not_to be_able_to(:show_protester_info, GrossExport) }
  end

  describe 'AttendanceReport' do
    it { is_expected.not_to be_able_to(:create, AttendanceReport) }
  end

  describe 'EvaluationExport' do
    let(:evaluation_export) { create(:evaluation_export) }

    it { is_expected.to be_able_to(:create, evaluation_export) }
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
      let(:other) { create(:user, :operator) }

      it { is_expected.not_to be_able_to(:edit, other) }
      it { is_expected.not_to be_able_to(:update, other) }
    end
  end

  describe 'Ticket' do

    let(:ticket) { create(:ticket, :with_parent, :in_sectoral_attendance, organ: organ, subnet: subnet) }
    let(:parent) { ticket.parent }

    let(:other_subnet) { create(:subnet, organ: organ) }
    let(:ticket_from_other_subnet) { create(:ticket, :with_parent, :in_sectoral_attendance, :with_subnet, organ: organ, subnet: other_subnet) }
    let(:ticket_finalized) { create(:ticket, :with_parent, :replied, organ: organ, subnet: subnet) }


    context 'manage' do
      let(:ticket_created_by_user_from_other_organ) { create(:ticket, :with_parent, created_by: user) }

      it { is_expected.to be_able_to(:create, Ticket) }
      it { is_expected.to be_able_to(:search, Ticket) }

      it { is_expected.to be_able_to(:read, ticket) }

      it { is_expected.not_to be_able_to(:edit, ticket) }
      it { is_expected.not_to be_able_to(:update, ticket) }

      it { is_expected.to be_able_to(:read, ticket_created_by_user_from_other_organ) }

      it { is_expected.not_to be_able_to(:edit, ticket_created_by_user_from_other_organ) }
      it { is_expected.not_to be_able_to(:update, ticket_created_by_user_from_other_organ) }
    end

    context 'history' do
      let(:ticket) { create(:ticket, :with_parent, organ: organ, subnet: subnet) }
      let(:other_ticket) { create(:ticket, :with_parent) }
      let(:ticket_created_by_user) { create(:ticket, created_by: user) }

      it { is_expected.to be_able_to(:history, ticket) }
      it { is_expected.to be_able_to(:history, ticket.parent) }
      it { is_expected.to be_able_to(:history, ticket_created_by_user) }

      it { is_expected.not_to be_able_to(:history, other_ticket) }
      it { is_expected.not_to be_able_to(:history, other_ticket.parent) }
    end

    context 'publish_ticket' do
      it { is_expected.not_to be_able_to(:publish_ticket, Ticket) }
    end

    context 'extension' do
      it { is_expected.not_to be_able_to(:extend, Ticket) }
      it { is_expected.not_to be_able_to(:cancel_extend, Ticket) }

      context 'extension with status' do
        context 'in_progress' do
          before { create(:extension, ticket: ticket, status: :in_progress) }

          it { is_expected.to be_able_to(:approve_extension, ticket) }
          it { is_expected.to be_able_to(:reject_extension, ticket) }
        end

        context 'approved' do
          before { create(:extension, ticket: ticket, status: :approved) }

          it { is_expected.not_to be_able_to(:approve_extension, ticket) }
          it { is_expected.not_to be_able_to(:reject_extension, ticket) }
        end

        context 'rejected' do
          before { create(:extension, ticket: ticket, status: :rejected) }

          it { is_expected.to be_able_to(:approve_extension, ticket) }
          it { is_expected.to be_able_to(:reject_extension, ticket) }
        end

        context 'cancelled' do
          before { create(:extension, ticket: ticket, status: :cancelled) }

          it { is_expected.to be_able_to(:approve_extension, ticket) }
          it { is_expected.to be_able_to(:reject_extension, ticket) }
        end
      end

      context 'when ticket replied' do
        it { is_expected.not_to be_able_to(:approve_extension, ticket_finalized) }
        it { is_expected.not_to be_able_to(:reject_extension, ticket_finalized) }
      end
    end

    context 'change_type' do
      it { is_expected.to be_able_to(:change_type, Ticket) }
    end

    context 'change_sou_type' do
      it { is_expected.to be_able_to(:change_sou_type, Ticket) }
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
        let(:ticket_replied) { create(:ticket, :with_parent, :replied, organ: organ, subnet: subnet) }

        it { is_expected.not_to be_able_to(:can_view_deadline, ticket_replied) }
      end

      context 'ticket partial_answer' do
        let(:ticket_partial_answer) { create(:ticket, :with_parent, internal_status: :partial_answer, organ: organ, subnet: subnet) }

        it { is_expected.not_to be_able_to(:can_view_deadline, ticket_partial_answer) }
      end
    end

    context 'global_tickets_index' do
      it { is_expected.not_to be_able_to(:global_tickets_index, Ticket) }
    end

    context 'invalidate' do
      it { is_expected.not_to be_able_to(:invalidate, Ticket) }
      it { is_expected.not_to be_able_to(:approve_invalidation, Ticket) }
      it { is_expected.not_to be_able_to(:reject_invalidation, Ticket) }
    end

    context 'clone_ticket' do
      it { is_expected.not_to be_able_to(:clone_ticket, Ticket) }
    end

    context 'forward' do
      context 'classified' do
        before do
          create(:classification, ticket: ticket)
          create(:classification, ticket: ticket_from_other_subnet)
        end

        it { is_expected.to be_able_to(:forward, ticket) }
        it { is_expected.not_to be_able_to(:forward, ticket_from_other_subnet) }
      end

      context 'not classified' do
        it { is_expected.not_to be_able_to(:forward, ticket) }
        it { is_expected.not_to be_able_to(:forward, ticket_from_other_subnet) }
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
      let(:old_ticket) { create(:ticket, :with_parent, :in_sectoral_attendance, organ: organ, subnet: subnet, confirmed_at: 1.month.ago) }

      it { is_expected.to be_able_to(:share, ticket) }

      it { is_expected.not_to be_able_to(:share, old_ticket) }
      it { is_expected.not_to be_able_to(:share, ticket_from_other_subnet) }
      it { is_expected.not_to be_able_to(:share, ticket_finalized) }

      it 'partial_answer' do
        ticket.partial_answer!
        is_expected.not_to be_able_to(:share, ticket)
      end

      context 'delete' do
        it { is_expected.not_to be_able_to(:delete_share, Ticket) }
      end
    end

    context 'transfer_organ' do
      let(:new_ticket) do
        date = (Date.today - 4.days).to_datetime
        ticket.update_column(:confirmed_at, date)
        ticket
      end

      let(:old_ticket) do
        limit_days_to_share = Holiday.next_weekday(Ticket::CGE_SHARE_DEADLINE)
        date = (Date.today - limit_days_to_share.days).to_datetime
        ticket.update_column(:confirmed_at, date)
        ticket
      end

      it { is_expected.to be_able_to(:transfer_organ, ticket) }

      it { is_expected.not_to be_able_to(:transfer_organ, ticket_from_other_subnet) }
      it { is_expected.not_to be_able_to(:transfer_organ, ticket_finalized) }

      context 'when operator belongs to organ CGE' do
        let(:organ) { create(:executive_organ, :cge) }

        it { is_expected.to be_able_to(:transfer_organ, new_ticket) }
        it { is_expected.to_not be_able_to(:transfer_organ, old_ticket) }
      end

      context 'before 5 days' do
        it { is_expected.to be_able_to(:transfer_organ, new_ticket) }
      end

      context 'after 5 days' do
        it { is_expected.not_to be_able_to(:transfer_organ, old_ticket) }
      end
    end

    context 'transfer_department' do
      it { is_expected.not_to be_able_to(:transfer_department, TicketDepartment) }
    end

    context 'appeal' do
      let(:ticket_sic) { create(:ticket, :sic, :with_parent_sic, :replied, organ: organ, subnet: subnet) }
      let(:ticket_created_by_user) { create(:ticket, :sic, :replied, created_by: user) }

      it { is_expected.not_to be_able_to(:appeal, ticket) }
      it { is_expected.not_to be_able_to(:appeal, ticket_sic) }

      it { is_expected.to be_able_to(:appeal, ticket_created_by_user) }
    end

    context 'reopen' do
      let(:ticket_sic) { create(:ticket, :sic, :with_parent_sic, :replied, organ: organ, subnet: subnet) }
      let(:ticket_created_by_user) { create(:ticket, :replied, created_by: user) }

      it { is_expected.not_to be_able_to(:reopen, ticket) }
      it { is_expected.not_to be_able_to(:reopen, ticket_sic) }

      it { is_expected.to be_able_to(:reopen, ticket_created_by_user) }

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
      it { is_expected.to be_able_to(:immediate_answer, Ticket) }
    end

    context 'classify' do
      context 'ticket parent' do
        context 'without children' do
          let(:parent) { create(:ticket) }

          it { is_expected.to be_able_to(:classify, parent) }
        end

        context 'with children' do
          it { is_expected.not_to be_able_to(:classify, parent) }
        end

        context 'with inactive children' do
          before { ticket.final_answer! }

          it { is_expected.to be_able_to(:classify, parent) }
        end
      end

      context 'child' do
        it { is_expected.to be_able_to(:classify, ticket) }

        it 'answered ticket' do
          ticket.cge_validation!
          is_expected.not_to be_able_to(:classify, ticket)
        end
      end
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
      it { is_expected.not_to be_able_to(:answer, Ticket) }
    end

    context 'view user info' do
      it { is_expected.to be_able_to(:view_user_info, ticket) }
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
    let(:ticket) { create(:ticket, :with_parent, organ: organ, subnet: subnet) }
    let(:ticket_department) { create(:ticket_department, ticket: ticket) }

    let(:ticket_from_other_subnet) { create(:ticket, :with_parent) }
    let(:ticket_department_from_other_organ) { create(:ticket_department, ticket: ticket_from_other_subnet) }

    let(:ticket_finalized) { create(:ticket, :with_parent, :replied, organ: organ, subnet: subnet) }
    let(:ticket_department_finalized) { create(:ticket_department, ticket: ticket_finalized) }

    it { is_expected.to be_able_to(:edit, ticket_department) }
    it { is_expected.to be_able_to(:update, ticket_department) }
    it { is_expected.to be_able_to(:poke, ticket_department) }

    it { is_expected.not_to be_able_to(:edit, ticket_department_from_other_organ) }
    it { is_expected.not_to be_able_to(:update, ticket_department_from_other_organ) }
    it { is_expected.not_to be_able_to(:poke, ticket_department_from_other_organ) }

    it { is_expected.not_to be_able_to(:edit, ticket_department_finalized) }
    it { is_expected.not_to be_able_to(:update, ticket_department_finalized) }
    it { is_expected.not_to be_able_to(:poke, ticket_department_finalized) }
  end

  describe 'Department' do
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
    let(:ticket) { create(:ticket, :with_parent, organ: organ, subnet: subnet) }
    let(:answer) { build(:answer, ticket: ticket) }


    it { is_expected.not_to be_able_to(:approve_answer, Answer) }
    it { is_expected.not_to be_able_to(:reject_answer, Answer) }
    it { is_expected.not_to be_able_to(:edit_answer, Answer) }
    it { is_expected.to be_able_to(:view, Answer) }


    context 'change_answer_certificate' do
      context 'sou' do
        it { is_expected.not_to be_able_to(:change_answer_certificate, answer) }
      end

      context 'sic' do
        let(:ticket) { create(:ticket, :sic, :with_parent_sic, organ: organ, subnet: subnet) }

        it { is_expected.to be_able_to(:change_answer_certificate, answer) }
      end
    end

    context 'evaluate' do
      it { is_expected.not_to be_able_to(:evaluate, Answer) }
    end
  end

  describe 'AttendanceResponse' do
    it { is_expected.to be_able_to(:show, AttendanceResponse) }
    it { is_expected.not_to be_able_to(:create, AttendanceResponse) }
  end

  describe 'Comment' do
    let(:comment) { create(:comment) }

    it { is_expected.to be_able_to(:view, comment) }
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
      it {is_expected.to be_able_to(:answer_by_phone, user) }
    end
  end

  describe 'Operator SouEvaluationSamples' do
    it { is_expected.not_to be_able_to(:manage, Operator::SouEvaluationSample) }
  end

  describe 'Operator SouEvaluationSamples GeneratedList' do
    it { is_expected.not_to be_able_to(:manage, Operator::SouEvaluationSamples::GeneratedList) }
  end
end