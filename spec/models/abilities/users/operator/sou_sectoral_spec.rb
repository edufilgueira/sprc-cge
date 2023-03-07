require 'rails_helper'
require 'cancan/matchers'

describe Abilities::Users::Operator::SouSectoral do

  let(:user) { create(:user, :operator_sou_sectoral, organ: organ) }
  let(:organ) { create(:executive_organ) }

  subject(:ability) { Abilities::Users::Operator::SouSectoral.new(user) }

  describe 'Stats::Ticket' do
    context 'started' do
      let(:stats_ticket) { build(:stats_ticket, organ: organ, status: :started) }

      it { is_expected.not_to be_able_to(:create, stats_ticket) }
    end

    context 'created' do
      let(:stats_ticket) { build(:stats_ticket, organ: organ, status: :created) }

      it { is_expected.to be_able_to(:create, stats_ticket) }

      context 'without organ defined' do
        let(:stats_ticket) { build(:stats_ticket, status: :created) }

        it { is_expected.to be_able_to(:create, stats_ticket) }
      end

      context 'with other organ defined' do
        let(:other_organ) { create(:executive_organ) }
        let(:stats_ticket) { build(:stats_ticket, organ: other_organ, status: :created) }

        it { is_expected.not_to be_able_to(:create, stats_ticket) }
      end
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
    let(:evaluation_export) { create(:evaluation_export, :sou) }
    let(:sic) { create(:evaluation_export, :sic) }

    it { is_expected.to be_able_to(:create, evaluation_export) }
    it { is_expected.not_to be_able_to(:create, sic) }

    context 'when user.acts_as_sic is true' do
      before { user.acts_as_sic = true }

      it { is_expected.to be_able_to(:create, sic) }
    end
  end

  describe 'User' do
    it { is_expected.to be_able_to(:new, User) }
    it { is_expected.to be_able_to(:create, User) }

    context 'itself' do
      it { is_expected.to be_able_to(:show, user) }
      it { is_expected.to be_able_to(:edit, user) }
      it { is_expected.to be_able_to(:update, user) }
      it { is_expected.to be_able_to(:index, user) }
    end

    context 'operator from same organ' do
      let(:other_operator_from_same_organ) { create(:user, :operator_sectoral, organ: user.organ) }

      it { is_expected.to be_able_to(:index, other_operator_from_same_organ) }
      it { is_expected.to be_able_to(:create, other_operator_from_same_organ) }
      it { is_expected.to be_able_to(:show, other_operator_from_same_organ) }
      it { is_expected.not_to be_able_to(:edit, other_operator_from_same_organ) }
      it { is_expected.not_to be_able_to(:update, other_operator_from_same_organ) }
      it { is_expected.not_to be_able_to(:destroy, other_operator_from_same_organ) }
    end

    context 'operator from other organ' do
      let(:operator_from_another_organ) { create(:user, :operator_sectoral) }

      it { is_expected.not_to be_able_to(:index, operator_from_another_organ) }
      it { is_expected.not_to be_able_to(:create, operator_from_another_organ) }
      it { is_expected.not_to be_able_to(:show, operator_from_another_organ) }
      it { is_expected.not_to be_able_to(:edit, operator_from_another_organ) }
      it { is_expected.not_to be_able_to(:update, operator_from_another_organ) }
      it { is_expected.not_to be_able_to(:destroy, operator_from_another_organ) }
    end

    context 'operator subnet' do
      let(:subnet_user) {  create(:user, :operator_subnet, organ: organ) }
      let(:subnet_user_other_organ) {  create(:user, :operator_subnet) }

      it { is_expected.to be_able_to(:index, subnet_user) }
      it { is_expected.to be_able_to(:create, subnet_user) }
      it { is_expected.to be_able_to(:show, subnet_user) }
      it { is_expected.to be_able_to(:update, subnet_user) }

      it { is_expected.not_to be_able_to(:create, subnet_user_other_organ) }
    end
  end

  describe 'Ticket' do

    let(:ticket) { create(:ticket, :with_parent, :in_sectoral_attendance, organ: organ) }
    let(:parent) { ticket.parent }

    let(:ticket_from_other_organ) { create(:ticket, :with_parent, :confirmed) }
    let(:ticket_finalized) { create(:ticket, :with_parent, :replied, organ: organ) }

    let(:ticket_sic) { create(:ticket, :sic, :with_parent_sic, :in_sectoral_attendance, organ: organ) }

    context 'manage' do

      it { is_expected.to be_able_to(:create, Ticket) }
      it { is_expected.to be_able_to(:search, Ticket) }
      it { is_expected.to be_able_to(:read, Ticket.new) }

      context 'sic' do
        let(:ticket_created_by_user) { create(:ticket, :sic, :with_parent_sic, created_by: user) }

        it { is_expected.not_to be_able_to(:edit, ticket_sic) }
        it { is_expected.not_to be_able_to(:update, ticket_sic) }
        it { is_expected.not_to be_able_to(:read, ticket_sic) }

        it { is_expected.to be_able_to(:read, ticket_created_by_user) }

        it { is_expected.not_to be_able_to(:edit, ticket_created_by_user) }
        it { is_expected.not_to be_able_to(:update, ticket_created_by_user) }

        context 'when user.acts_as_sic is ' do
          context 'true' do
            before { user.acts_as_sic = true }

            it { is_expected.to be_able_to(:read, ticket_sic) }
          end

          context 'false' do
            before { user.acts_as_sic = false }

            it { is_expected.not_to be_able_to(:read, ticket_sic) }
          end
        end
      end

      context 'sou' do
        let(:ticket_created_by_user_from_other_organ) { create(:ticket, :with_parent, created_by: user) }

        it { is_expected.to be_able_to(:edit, ticket) }
        it { is_expected.to be_able_to(:update, ticket) }
        it { is_expected.to be_able_to(:read, ticket) }

        it { is_expected.to be_able_to(:read, ticket_created_by_user_from_other_organ) }
        it { is_expected.not_to be_able_to(:edit, ticket_created_by_user_from_other_organ) }
        it { is_expected.not_to be_able_to(:update, ticket_created_by_user_from_other_organ) }

        it { is_expected.not_to be_able_to(:update, ticket_finalized) }
      end

      context 'denunciation' do
        let(:denunciation) { create(:ticket, :with_parent, :denunciation, organ: organ) }

        it { is_expected.to be_able_to(:read, denunciation) }
      end

      context 'denunciation not sectoral_denunciation' do
        let(:user) { create(:user, :operator_sou_sectoral, sectoral_denunciation: false, organ: organ) }
        let(:denunciation) { create(:ticket, :with_parent, :denunciation, organ: organ) }

        it { is_expected.not_to be_able_to(:read, denunciation) }
      end
    end

    context 'history' do
      let(:ticket) { create(:ticket, :with_parent, organ: organ) }
      let(:other_ticket) { create(:ticket, :with_parent) }
      let(:ticket_created_by_user) { create(:ticket, created_by: user) }

      it { is_expected.to be_able_to(:history, ticket) }
      it { is_expected.to be_able_to(:history, ticket.parent) }
      it { is_expected.to be_able_to(:history, ticket_created_by_user) }

      it { is_expected.not_to be_able_to(:history, other_ticket) }
      it { is_expected.not_to be_able_to(:history, other_ticket.parent) }

      it { is_expected.not_to be_able_to(:history, ticket_sic) }

      context 'when user.acts_as_sic = true' do
        before { user.acts_as_sic = true }

        it { is_expected.to be_able_to(:history, ticket_sic) }
        it { is_expected.to be_able_to(:history, ticket_sic.parent) }
      end
    end

    context 'publish_ticket' do
      it { is_expected.not_to be_able_to(:publish_ticket, Ticket) }
    end

    context 'extension' do
      let(:ticket_out_limit_extend) do
        ticket_days = Ticket::LIMIT_TO_EXTEND_DEADLINE + 5
        exceeded_limit = DateTime.now - ticket_days.days
        create(:ticket, :with_parent, deadline: Ticket::SOU_DEADLINE - ticket_days, confirmed_at: exceeded_limit, organ: organ)
      end

      it { is_expected.to be_able_to(:extend, ticket) }
      it { is_expected.not_to be_able_to(:extend, ticket_out_limit_extend) }

      it { is_expected.not_to be_able_to(:approve_extension, Ticket) }
      it { is_expected.not_to be_able_to(:reject_extension, Ticket) }

      context 'with another extension created with status' do
        context 'in_progress' do
          before { create(:extension, ticket: ticket, status: :in_progress) }

          it { is_expected.not_to be_able_to(:extend, ticket) }
          it { is_expected.to be_able_to(:cancel_extend, ticket) }
        end
        context 'approved' do
          before { create(:extension, ticket: ticket, status: :approved) }

          it { is_expected.not_to be_able_to(:extend, ticket) }
          it { is_expected.not_to be_able_to(:cancel_extend, ticket) }
        end
        context 'rejected' do
          before { create(:extension, ticket: ticket, status: :rejected) }

          it { is_expected.to be_able_to(:extend, ticket) }
          it { is_expected.not_to be_able_to(:cancel_extend, ticket) }
        end
        context 'cancelled' do
          before { create(:extension, ticket: ticket, status: :cancelled) }

          it { is_expected.to be_able_to(:extend, ticket) }
          it { is_expected.not_to be_able_to(:cancel_extend, ticket) }
        end
      end

      context 'when ticket replied' do
        let(:ticket_replied) { create(:ticket, :with_parent, :replied, organ: organ) }

        it { is_expected.not_to be_able_to(:extend, ticket_replied) }
        it { is_expected.not_to be_able_to(:cancel_extend, ticket_replied) }
      end

      context 'ticket partial_answer' do
        let(:ticket_partial_answer) { create(:ticket, :with_parent, internal_status: :partial_answer, organ: organ) }

        it { is_expected.not_to be_able_to(:cancel_extend, ticket_partial_answer) }
      end

      context 'when user.acts_as_sic is ' do

        context 'true' do
          before { user.acts_as_sic = true }

          it { is_expected.to be_able_to(:extend, ticket_sic) }

          context 'with another extension created with status' do
            before { create(:extension, ticket: ticket_sic, status: :in_progress) }
            it { is_expected.to be_able_to(:cancel_extend, ticket_sic) }
          end
        end

        context 'false' do
          before { user.acts_as_sic = false }

          it { is_expected.not_to be_able_to(:extend, ticket_sic) }
          it { is_expected.not_to be_able_to(:cancel_extend, ticket_sic) }
        end
      end
    end

    context 'change_type' do
      let(:ticket_anonymous) { create(:ticket, :anonymous) }

      it { is_expected.to be_able_to(:change_type, ticket) }
      it { is_expected.not_to be_able_to(:change_type, ticket_anonymous) }

      context 'when user.acts_as_sic is ' do

        context 'true' do
          before { user.acts_as_sic = true }

          it { is_expected.to be_able_to(:change_type, ticket_sic) }
        end

        context 'false' do
          before { user.acts_as_sic = false }

          it { is_expected.not_to be_able_to(:change_type, ticket_sic) }
        end
      end
    end

    context 'rede_ouvir' do
      before { ticket.update(rede_ouvir: true) }

      it { is_expected.not_to be_able_to(:change_type, ticket) }
    end

    context 'blank document' do
      before { ticket.update(document: '') }

      it { is_expected.not_to be_able_to(:change_type, ticket) }
    end

    context 'change_sou_type' do
      let(:ticket_denunciation) { create(:ticket, :denunciation) }

      it { is_expected.to be_able_to(:change_sou_type, ticket) }
      it { is_expected.not_to be_able_to(:change_sou_type, ticket_denunciation) }

      it 'when ticket`s owner' do
        allow(ticket).to receive(:created_by).and_return(user)

        is_expected.not_to be_able_to(:change_sou_type, ticket)
      end

      it 'when cannot edit' do
        allow(ability).to receive(:can?).with(anything, anything).and_call_original
        allow(ability).to receive(:can?).with(:edit, ticket).and_return(false)

        is_expected.not_to be_able_to(:change_sou_type, ticket)
      end
    end

    context 'change_answer_type_label with denunciation' do
      let(:denunciation_ticket) { create(:ticket, :denunciation) }

      it { is_expected.not_to be_able_to(:view_answer_type_label, denunciation_ticket) }
    end

    context 'change_answer_type_label without denunciation' do
      let(:denunciation_ticket) { create(:ticket) }

      it { is_expected.to be_able_to(:view_answer_type_label, denunciation_ticket) }
    end

    context 'view answer type' do
      let(:ticket) { create(:ticket, :denunciation) }

      it { is_expected.to be_able_to(:view_answer_type, ticket) }
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
      it { is_expected.to be_able_to(:global_tickets_index, Ticket) }
    end

    context 'invalidate' do
      it { is_expected.to be_able_to(:invalidate, ticket) }
      it { is_expected.not_to be_able_to(:invalidate, ticket_from_other_organ) }

      it { is_expected.not_to be_able_to(:approve_invalidation, Ticket) }
      it { is_expected.not_to be_able_to(:reject_invalidation, Ticket) }

      it 'ticket already answered' do
        answered_ticket = create(:ticket, :with_parent, internal_status: :final_answer, organ: organ)
        create(:answer, :user_evaluated, ticket: answered_ticket)

        is_expected.not_to be_able_to(:invalidate, answered_ticket)
      end

      it 'ticket already invalidated' do
        invalidated_ticket = create(:ticket, :with_parent, :invalidated, organ: organ)

        is_expected.not_to be_able_to(:invalidate, invalidated_ticket)
      end

      it 'child already approved' do
        child = create(:ticket, :with_parent, organ: organ)

        data_waiting = { status: :waiting }
        create(:ticket_log, action: :invalidate, ticket: child, data: data_waiting)

        data_approved = { status: :approved }
        create(:ticket_log, action: :invalidate, ticket: child, data: data_approved)

        is_expected.not_to be_able_to(:invalidate, child)
      end

      it 'child with pending invalidation' do
        child = create(:ticket, :with_parent, organ: organ)

        data_waiting = { status: :waiting }
        create(:ticket_log, action: :invalidate, ticket: child, data: data_waiting)

        is_expected.not_to be_able_to(:invalidate, child)
      end

      context 'when user.acts_as_sic is ' do
        context 'true' do
          before { user.acts_as_sic = true }

          it { is_expected.to be_able_to(:invalidate, ticket_sic) }
        end

        context 'false' do
          before { user.acts_as_sic = false }

          it { is_expected.not_to be_able_to(:invalidate, ticket_sic) }
        end
      end
    end

    context 'clone_ticket' do
      it { is_expected.to be_able_to(:clone_ticket, ticket) }
      it { is_expected.not_to be_able_to(:clone_ticket, ticket_from_other_organ) }

      context 'when user.acts_as_sic is ' do
        context 'true' do
          before { user.acts_as_sic = true }

          it { is_expected.to be_able_to(:clone_ticket, ticket_sic) }
        end

        context 'false' do
          before { user.acts_as_sic = false }

          it { is_expected.not_to be_able_to(:clone_ticket, ticket_sic) }
        end
      end
    end

    context 'forward' do
      context 'classified' do
        before { create(:classification, ticket: ticket) }
        before { create(:classification, ticket: ticket_sic) }

        it { is_expected.to be_able_to(:forward, ticket) }


        context 'when user.acts_as_sic is ' do
          context 'true' do
            before { user.acts_as_sic = true }

            it { is_expected.to be_able_to(:forward, ticket_sic) }
          end

          context 'false' do
            before { user.acts_as_sic = false }

            it { is_expected.not_to be_able_to(:forward, ticket_sic) }
          end
        end

        context 'rede_ouvir' do
          before { ticket.update(rede_ouvir: true) }

          it { is_expected.not_to be_able_to(:forward, ticket) }
        end
      end

      context 'not classified' do
        it { is_expected.not_to be_able_to(:forward, ticket) }
      end


      it { is_expected.not_to be_able_to(:forward, ticket_from_other_organ) }

      context 'finalized' do
        let(:parent_finalizer) do
          parent = ticket_finalized.parent
          parent.final_answer!
          parent
        end

        it { is_expected.not_to be_able_to(:forward, ticket_finalized) }
        it { is_expected.not_to be_able_to(:forward, parent_finalizer) }
      end

      context 'cge_validation' do
        before do
          create(:classification, ticket: ticket)
          parent = ticket.parent

          ticket.cge_validation!
          parent.cge_validation!
        end

        it { is_expected.not_to be_able_to(:forward, ticket) }
        it { is_expected.not_to be_able_to(:forward, ticket.parent) }
      end
    end

    describe '#can_share_to_couvi_and_cosco' do
      context 'when ticket transfer/share to cosco' do
        it 'not be able' do
          is_expected.not_to be_able_to(:share_to_cosco, Ticket)
        end
      end

      context 'when ticket transfer/share to couvi' do
        context 'when user organ is cge' do
          it 'be able' do
            organ = user.organ
            organ.acronym = ExecutiveOrgan::COMPTROLLER_ACRONYM
            is_expected.to be_able_to(:share_to_couvi, Ticket)
          end
        end

        context 'when user organ is not cge' do
          it 'not be able' do
            is_expected.not_to be_able_to(:share_to_couvi, Ticket)
          end
        end
      end
    end

    describe '#share_internal_area' do
      let(:department) { create(:department, organ: organ) }
      let(:ticket_department) { create(:ticket_department, ticket: ticket, department: department) }
      let(:appeal_ticket) { create(:ticket, :with_appeal) }

      context 'with partial answer' do
        it 'be able to internal area' do
          ticket.partial_answer!
          is_expected.to be_able_to(:share_internal_area, ticket)
        end
      end

      context 'without partial answer' do
        it 'be able to internal area' do
          ticket.sectoral_attendance!
          is_expected.to be_able_to(:share_internal_area, ticket)
        end
      end

      context 'user organ is the same of ticket organ' do
        it 'be able to internal area' do
          is_expected.to be_able_to(:share_internal_area, ticket)
        end
      end

      context 'user organ is different from ticket organ' do
        it 'not be able to internal area' do
          is_expected.to_not be_able_to(:share_internal_area, ticket_from_other_organ)
        end
      end

      context 'internal status is appeal' do       
        it 'not be able to internal area' do
          is_expected.not_to be_able_to(:share_internal_area, appeal_ticket)
        end
      end
    end

    describe '#can_delete_share_ticket' do
      context 'when try to remove a organ share association' do
        it 'cant remove share to a organ' do
          is_expected.not_to be_able_to(:delete_share, Ticket)
        end
      end
    end

    # funcao responsavel por compartilhar ticket com outro orgao ou subrede
    describe '#can_share_ticket' do
      context 'when user organ is different from ticket organ' do
        it 'cant share to a organ' do
          is_expected.not_to be_able_to(:share, ticket_from_other_organ)
        end
      end

      context 'when ticket is finalized' do
        it 'cant share to a organ' do
          is_expected.not_to be_able_to(:share, ticket_finalized)
        end
      end

      context 'when associated a organ WITHOUT subnet' do
        context 'when ticket is sic' do
          let(:ticket_sic) { create(:ticket, :sic, :with_parent_sic, :in_sectoral_attendance) }
          let(:user) { create(:user, :operator_sou_sectoral, organ: ticket_sic.organ) }

          context 'when user can act as sic' do
            before { user.acts_as_sic = true }

            it 'can share to a organ' do
              is_expected.to be_able_to(:share, ticket_sic)
            end
          end

          context 'when user cant act as sic' do
            before { user.acts_as_sic = false }

            it 'cant share to a organ' do
              is_expected.not_to be_able_to(:share, ticket_sic)
            end
          end
        end

        context 'when ticket confirmed_at before 5 days' do
          let(:new_ticket) {
            ticket.confirmed_at = Date.today
            ticket
          }

          it 'can share to a organ' do
            is_expected.to be_able_to(:share, new_ticket)
          end
        end

        context 'when ticket confirmed_at after 5 days' do
          let(:old_ticket) { create(:ticket, :with_parent, :in_sectoral_attendance, organ: organ, confirmed_at: 1.month.ago) }

          it 'cant share to a organ' do
            is_expected.not_to be_able_to(:share, old_ticket)
          end
        end

        context 'reopened ticket without a organ' do
          it 'not be able to share' do
            ticket = create(:ticket, :reopened_without_organ)
            is_expected.not_to be_able_to(:share, ticket)
          end
        end
      end

      context 'when associated a organ WITH subnet' do
        let(:ticket_with_subnet) { create(:ticket, :with_parent, :in_sectoral_attendance, :with_subnet) }
        let(:user) { create(:user, :operator_sou_sectoral, organ: ticket_with_subnet.organ) }

        context 'when ticket is sic' do
          let(:ticket_sic) { create(:ticket, :sic, :with_parent_sic, :in_sectoral_attendance, :with_subnet) }
          let(:user) { create(:user, :operator_sou_sectoral, organ: ticket_sic.organ) }

          context 'when user can act as sic' do
            before { user.acts_as_sic = true }

            it 'can share to other organ' do
              is_expected.to be_able_to(:share, ticket_sic)
            end
          end

          context 'when user cant act as sic' do
            before { user.acts_as_sic = false }

            it 'cant share to other organ' do
              is_expected.not_to be_able_to(:share, ticket_sic)
            end
          end
        end

        context 'when ticket confirmed_at before 5 days' do
          let(:new_ticket) {
            ticket_with_subnet.confirmed_at = Date.today
            ticket_with_subnet
          }

          it 'can share to a organ' do
            is_expected.to be_able_to(:share, new_ticket)
          end
        end

        context 'when ticket confirmed_at after 5 days' do
          let(:old_ticket) {
            ticket_with_subnet.confirmed_at = 1.month.ago
            ticket_with_subnet
          }

          it 'can share to a organ' do
            is_expected.to be_able_to(:share, old_ticket)
          end
        end
      end
    end

    # funcao responsavel por transferir ticket para um outro orgao ou subrede
    describe '#can_transfer_ticket' do
      context 'when user organ is different from ticket organ' do
        it 'cant share to a organ' do
          is_expected.not_to be_able_to(:transfer_organ, ticket_from_other_organ)
        end
      end

      context 'when ticket is finalized' do
        it 'cant share to a organ' do
          is_expected.not_to be_able_to(:transfer_organ, ticket_finalized)
        end
      end

      context 'when ticket associated a organ without subnet' do
        let(:user) { create(:user, :operator_sou_sectoral, organ: ticket.organ) }

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

        context 'when operator belongs to the same ticket organ' do
          context 'when ticket confirmed_at before 5 days' do
            it 'can transfer to a organ' do
              is_expected.to be_able_to(:transfer_organ, new_ticket)
            end
          end

          context 'when ticket confirmed_at after 5 days' do
            it 'cant transfer to a organ' do
              is_expected.not_to be_able_to(:transfer_organ, old_ticket)
            end
          end
        end

        context 'when ticket is sic' do
          let(:ticket_sic) { create(:ticket, :sic, :with_parent_sic, :in_sectoral_attendance) }
          let(:user) { create(:user, :operator_sou_sectoral, organ: ticket_sic.organ) }

          context 'when user can act as sic' do
            before { user.acts_as_sic = true }

            it 'can trasfer to other organ' do
              is_expected.to be_able_to(:transfer_organ, ticket_sic)
            end
          end

          context 'when user cant act as sic' do
            before { user.acts_as_sic = false }

            it 'cant trasfer to other organ' do
              is_expected.not_to be_able_to(:transfer_organ, ticket_sic)
            end
          end
        end
      end

      context 'when ticket associated a organ with subnet' do
        let(:ticket_with_subnet) { create(:ticket, :with_parent, :in_sectoral_attendance, :with_subnet) }
        let(:user) { create(:user, :operator_sou_sectoral, organ: ticket_with_subnet.organ) }

        let(:new_ticket) do
          date = (Date.today - 4.days).to_datetime
          ticket_with_subnet.update_column(:confirmed_at, date)
          ticket_with_subnet
        end

        let(:old_ticket) do
          limit_days_to_share = Holiday.next_weekday(Ticket::CGE_SHARE_DEADLINE)
          date = (Date.today - limit_days_to_share.days).to_datetime
          ticket_with_subnet.update_column(:confirmed_at, date)
          ticket_with_subnet
        end

        context 'when operator belongs to the same ticket organ' do
          context 'when ticket confirmed_at before 5 days' do
            it 'can trasfer to other organ' do
              is_expected.to be_able_to(:transfer_organ, new_ticket)
            end
          end

          context 'when ticket confirmed_at after 5 days' do
            it 'can trasfer to other organ' do
              is_expected.to be_able_to(:transfer_organ, old_ticket)
            end
          end
        end

        context 'when ticket is sic' do
          let(:ticket_sic) { create(:ticket, :sic, :with_parent_sic, :in_sectoral_attendance, :with_subnet) }
          let(:user) { create(:user, :operator_sou_sectoral, organ: ticket_sic.organ) }

          context 'when user can act as sic' do
            before { user.acts_as_sic = true }

            it 'can trasfer to other organ' do
              is_expected.to be_able_to(:transfer_organ, ticket_sic)
            end
          end

          context 'when user cant act as sic' do
            before { user.acts_as_sic = false }

            it 'cant trasfer to other organ' do
              is_expected.not_to be_able_to(:transfer_organ, ticket_sic)
            end
          end
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
          ticket_child = create(:ticket, :with_parent, :with_classification, organ: user.organ)
          is_expected.to be_able_to(:transfer_organ, ticket_child)
        end
      end
    end

    context 'transfer_department' do
      it { is_expected.not_to be_able_to(:transfer_department, TicketDepartment) }
    end

    context 'appeal' do
      let(:ticket_sic) { create(:ticket, :sic, :with_parent_sic, :replied, organ: organ) }
      let(:ticket_created_by_user) { create(:ticket, :sic, :replied, created_by: user) }

      it { is_expected.not_to be_able_to(:appeal, ticket) }
      it { is_expected.not_to be_able_to(:appeal, ticket_sic) }

      it { is_expected.to be_able_to(:appeal, ticket_created_by_user) }
    end

    context 'reopen' do
      let(:ticket_sic) { create(:ticket, :sic, :with_parent_sic, :replied, organ: organ) }
      let(:ticket_sou) { create(:ticket, :with_parent, :replied, organ: organ) }
      let(:ticket_created_by_user) { create(:ticket, :replied, created_by: user) }
      let(:ticket_sou_reopened) { create(:ticket, :with_parent, :replied, organ: organ, created_by: user, reopened: 1) }
      let(:ticket_sic_reopened) { create(:ticket, :sic, :with_parent, :replied, organ: organ, created_by: user, reopened: 1) }

      it { is_expected.not_to be_able_to(:reopen, ticket) }
      it { is_expected.to be_able_to(:reopen, ticket_sic) }
      it { is_expected.not_to be_able_to(:reopen, ticket_sou_reopened) }
      it { is_expected.to be_able_to(:reopen, ticket_sic_reopened) }
      it { is_expected.to be_able_to(:reopen, ticket_sou) }
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
      it { is_expected.to be_able_to(:create_public_comment, ticket) }
      it { is_expected.not_to be_able_to(:create_public_comment, ticket_finalized) }

      it { is_expected.to be_able_to(:view_public_comment, Ticket) }

      context 'when user.acts_as_sic is ' do
        context 'true' do
          before { user.acts_as_sic = true }

          it { is_expected.to be_able_to(:create_public_comment, ticket_sic) }
        end

        context 'false' do
          before { user.acts_as_sic = false }

          it { is_expected.not_to be_able_to(:create_public_comment, ticket_sic) }
        end
      end
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

      context 'when user.acts_as_sic is ' do
        context 'true' do
          before { user.acts_as_sic = true }

          it { is_expected.to be_able_to(:classify, ticket_sic) }
        end

        context 'false' do
          before { user.acts_as_sic = false }

          it { is_expected.not_to be_able_to(:classify, ticket_sic) }
        end
      end

      context 'rede_ouvir' do
        before { ticket.update(rede_ouvir: true) }

        it { is_expected.not_to be_able_to(:classify, ticket) }
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
      it { is_expected.not_to be_able_to(:answer, parent) }

      context 'when ticket classified' do
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

          context 'appeal' do
            before { ticket.appeal!}

            it { is_expected.to be_able_to(:answer, ticket) }
          end
        end
      end

      context 'when ticket not classified' do
        it { is_expected.not_to be_able_to(:answer, ticket) }
      end

      context 'when ticket already answered' do
        let(:ticket) { create(:ticket, :with_parent, :with_classification, :replied, organ: organ) }

        it { is_expected.not_to be_able_to(:answer, ticket) }
      end

      context 'with partial_answer' do
        before do
          ticket.partial_answer!
          create(:classification, ticket: ticket)
          create(:answer, :sectoral_approved, ticket: ticket, answer_type: :partial)
        end

        it { is_expected.to be_able_to(:answer, ticket) }
      end

      context 'when user.acts_as_sic is ' do
        before { create(:classification, ticket: ticket_sic) }

        context 'true' do
          before { user.acts_as_sic = true }

          it { is_expected.to be_able_to(:answer, ticket_sic) }
        end

        context 'false' do
          before { user.acts_as_sic = false }

          it { is_expected.not_to be_able_to(:answer, ticket_sic) }
        end
      end
    end

    context 'view user info' do
      let(:ticket_denunciation) { create(:ticket, :denunciation) }

      it { is_expected.to be_able_to(:view_user_info, ticket) }
      it { is_expected.not_to be_able_to(:view_user_info, ticket_denunciation) }

      context 'when user.acts_as_sic is ' do
        context 'true' do
          before { user.acts_as_sic = true }

          it { is_expected.to be_able_to(:view_user_info, ticket_sic) }
        end

        context 'false' do
          before { user.acts_as_sic = false }

          it { is_expected.not_to be_able_to(:view_user_info, ticket_sic) }
        end
      end
    end

    context 'view user password' do
      let(:ticket_denunciation) { create(:ticket, :denunciation, organ: user.organ) }

      it { is_expected.to be_able_to(:view_user_password, ticket) }
      it { is_expected.to be_able_to(:view_user_password, ticket_denunciation) }
    end

    context 'note' do
      it { is_expected.not_to be_able_to(:edit_note, Ticket) }
      it { is_expected.not_to be_able_to(:update_note, Ticket) }
    end

    context 'create_positioning' do
      it { is_expected.not_to be_able_to(:create_positioning, ticket) }

      context 'when user.positioning === true' do
        before { user.positioning = true }

        it { is_expected.not_to be_able_to(:create_positioning, ticket) }

        context 'and has department without answer' do
          before { create(:ticket_department, ticket: ticket) }

          it { is_expected.to be_able_to(:create_positioning, ticket) }
        end

        context 'when user.acts_as_sic is ' do
          before { create(:ticket_department, ticket: ticket_sic) }

          context 'true' do
            before { user.acts_as_sic = true }

            it { is_expected.to be_able_to(:create_positioning, ticket_sic) }
          end

          context 'false' do
            before { user.acts_as_sic = false }

            it { is_expected.not_to be_able_to(:create_positioning, ticket_sic) }
          end
        end
      end
    end

    context 'denunciation' do
      it { is_expected.not_to be_able_to(:view_denunciation, Ticket) }
      it { is_expected.not_to be_able_to(:edit_denunciation_organ, Ticket) }
      it { is_expected.not_to be_able_to(:classify_denunciation, Ticket) }
    end

    context 'email_reply' do
      it { is_expected.not_to be_able_to(:email_reply, ticket) }

      context 'replied' do
        let!(:answer) { create(:answer, :cge_approved, ticket: ticket_finalized) }

        it { is_expected.to be_able_to(:email_reply, ticket_finalized) }
      end

      context 'when answer.status is' do
        context 'cge_approved' do
          let(:answer) { create(:answer, :cge_approved, ticket: ticket_finalized) }

          it { is_expected.to be_able_to(:email_reply, ticket_finalized) }
        end

        context 'user_evaluated' do
          let(:answer) { create(:answer, :user_evaluated, ticket: ticket_finalized) }

          it { is_expected.to be_able_to(:email_reply, ticket_finalized) }
        end

        context 'call_center_approved' do
          let(:answer) { create(:answer, :call_center_approved, ticket: ticket_finalized) }

          it { is_expected.to be_able_to(:email_reply, ticket_finalized) }
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
    let(:ticket) { create(:ticket, :with_parent, organ: organ) }
    let(:ticket_department) { create(:ticket_department, ticket: ticket) }

    let(:ticket_from_other_organ) { create(:ticket, :with_parent) }
    let(:ticket_department_from_other_organ) { create(:ticket_department, ticket: ticket_from_other_organ) }

    let(:ticket_finalized) { create(:ticket, :with_parent, :replied, organ: organ) }
    let(:ticket_department_finalized) { create(:ticket_department, ticket: ticket_finalized) }

    let(:ticket_reopened) { create(:ticket, :with_reopen, organ: organ) }
    let(:ticket_department_reopened) { create(:ticket_department, ticket: ticket_reopened) }

    it { is_expected.to be_able_to(:edit, ticket_department) }
    it { is_expected.to be_able_to(:update, ticket_department) }
    it { is_expected.to be_able_to(:poke, ticket_department) }
    it { is_expected.not_to be_able_to(:renew_referral, ticket_department) }

    it { is_expected.to be_able_to(:renew_referral, ticket_department_reopened) }

    it { is_expected.not_to be_able_to(:edit, ticket_department_from_other_organ) }
    it { is_expected.not_to be_able_to(:update, ticket_department_from_other_organ) }
    it { is_expected.not_to be_able_to(:poke, ticket_department_from_other_organ) }
    it { is_expected.not_to be_able_to(:renew_referral, ticket_department_from_other_organ) }

    it { is_expected.not_to be_able_to(:edit, ticket_department_finalized) }
    it { is_expected.not_to be_able_to(:update, ticket_department_finalized) }
    it { is_expected.not_to be_able_to(:poke, ticket_department_finalized) }
    it { is_expected.not_to be_able_to(:renew_referral, ticket_department_finalized) }
  end

  describe 'Department' do
    let(:department) { create(:department, organ: organ) }
    let(:department_from_other_organ) { create(:department) }

    it { is_expected.to be_able_to(:index, department) }
    it { is_expected.to be_able_to(:create, department) }
    it { is_expected.to be_able_to(:edit, department) }
    it { is_expected.to be_able_to(:update, department) }
    it { is_expected.to be_able_to(:destroy, department) }

    it { is_expected.not_to be_able_to(:subnet_index, department) }
    it { is_expected.not_to be_able_to(:subnet_show, department) }

    it { is_expected.not_to be_able_to(:edit, department_from_other_organ) }
    it { is_expected.not_to be_able_to(:update, department_from_other_organ) }
    it { is_expected.not_to be_able_to(:destroy, department_from_other_organ) }

    context 'subnet department' do
      let(:organ) { create(:executive_organ, :with_subnet) }
      let(:subnet) { create(:subnet, organ: organ) }
      let(:department) { create(:department, :with_subnet, subnet: subnet) }

      it { is_expected.to be_able_to(:subnet_index, department) }
      it { is_expected.to be_able_to(:subnet_show, department) }
    end
  end

  describe 'Answer' do
    let(:ticket) { create(:ticket, :with_parent, organ: organ) }
    let(:answer) { build(:answer, ticket: ticket) }

    context 'manage' do
      it { is_expected.to be_able_to(:view, answer) }

      context 'when not awaiting' do
        it { is_expected.not_to be_able_to(:approve_answer, answer) }
        it { is_expected.not_to be_able_to(:reject_answer, answer) }
        it { is_expected.not_to be_able_to(:edit_answer, answer) }
      end

      context 'when awaiting' do
        before { answer.status = :awaiting }

        it { is_expected.not_to be_able_to(:approve_answer, answer) }
        it { is_expected.not_to be_able_to(:reject_answer, answer) }
        it { is_expected.not_to be_able_to(:edit_answer, answer) }

        context 'from department' do
          before { answer.answer_scope = :department }

          it { is_expected.to be_able_to(:approve_answer, answer) }
          it { is_expected.to be_able_to(:reject_answer, answer) }
          it { is_expected.not_to be_able_to(:edit_answer, answer) }
        end

        context 'from subnet' do
          before { answer.answer_scope = :subnet }

          it { is_expected.to be_able_to(:approve_answer, answer) }
          it { is_expected.to be_able_to(:reject_answer, answer) }
          it { is_expected.to be_able_to(:edit_answer, answer) }
        end
      end
    end

    context 'change_answer_certificate' do
      context 'sou' do
        it { is_expected.not_to be_able_to(:change_answer_certificate, answer) }
      end

      context 'sic' do
        let(:ticket) { create(:ticket, :sic, :with_parent_sic, organ: organ) }

        context 'when acts_as_sic' do
          context 'true' do
            before { user.acts_as_sic = true }

            it { is_expected.to be_able_to(:change_answer_certificate, answer) }
          end

          context 'false' do
            before { user.acts_as_sic = false }

            it { is_expected.not_to be_able_to(:change_answer_certificate, answer) }
          end
        end
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

  describe 'User can restrict attachment for share with organ' do
    let(:denunciation) { create(:ticket, :denunciation) }
    context 'sectoral_denunciation true and user_type: operator' do

      it { is_expected.to be_able_to(:protect_attachment_on_share_with_organ, denunciation) }
      it { is_expected.not_to be_able_to(:protect_attachment_on_share_with_organ, Ticket.new) }
    end
    context 'sectoral_denunciation false and user_type: operator' do

      before { user.sectoral_denunciation = false }

      it { is_expected.not_to be_able_to(:protect_attachment_on_share_with_organ, denunciation) }
      it { is_expected.not_to be_able_to(:protect_attachment_on_share_with_organ, Ticket.new) }
    end
  end
  describe 'Operator SouEvaluationSamples' do
    it { is_expected.not_to be_able_to(:manage, Operator::SouEvaluationSample) }
  end

  describe 'Operator SouEvaluationSamples GeneratedList' do
    it { is_expected.not_to be_able_to(:manage, Operator::SouEvaluationSamples::GeneratedList) }
  end
end