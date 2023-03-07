require 'rails_helper'

describe Ticket::Scopes do

  subject(:ticket) { build(:ticket) }

  describe 'scopes' do
    describe '#need_update_deadline' do
      context 'when decrement_deadline is false' do
        it 'return empty' do
          ticket = create(:ticket, internal_status: :final_answer)
          expect(Ticket.need_update_deadline).to eq([])
        end
      end

      context 'when decrement_deadline is true' do
        context 'when deadline_updated_at is nil' do
          it 'return ticket' do
            ticket = create(:ticket, :confirmed)
            expect(Ticket.need_update_deadline).to eq([ticket])
          end
        end

        context 'when deadline_updated_at' do
          context 'is before today' do
            it 'return ticket' do
              ticket = create(:ticket, :confirmed, deadline_updated_at: Date.yesterday)
              expect(Ticket.need_update_deadline).to eq([ticket])
            end
          end

          context 'is today' do
            it 'return ticket' do
              ticket = create(:ticket, :confirmed, deadline_updated_at: Date.today)
              expect(Ticket.need_update_deadline).to eq([])
            end
          end
        end
      end
    end

    describe '#deadline_outdated' do
      context 'when decrement_deadline is false' do
        it 'return empty' do
          ticket = create(:ticket, internal_status: :final_answer)
          expect(Ticket.deadline_outdated).to eq([])
        end
      end

      context 'when decrement_deadline is true' do
        context 'when deadline_updated_at' do
          context 'is before today' do
            it 'return ticket list' do
              ticket = create(:ticket, :confirmed, deadline_updated_at: Date.yesterday)
              expect(Ticket.deadline_outdated).to eq([ticket])
            end
          end

          context 'is today' do
            it 'return empty' do
              ticket = create(:ticket, :confirmed, deadline_updated_at: Date.today)
              expect(Ticket.deadline_outdated).to eq([])
            end
          end
        end
      end
    end

    describe '#deadline_invalid' do
      context 'when decrement_deadline is false' do
        it 'return empty' do
          ticket = create(:ticket, internal_status: :final_answer)
          expect(Ticket.deadline_invalid).to eq([])
        end
      end

      context 'when decrement_deadline is true' do
        Ticket::INTERNAL_STATUSES_TO_LOCK_DEADLINE.each do |internal_status|
          context "when internal status is #{internal_status}" do
            it 'return ticket list' do
              ticket = create(:ticket, internal_status: internal_status)
              ticket.update_attribute(:decrement_deadline, true)

              expect(Ticket.deadline_invalid).to eq([ticket])
            end
          end
        end
      end
    end

    it 'first_confirmed_date' do
      ticket = create(:ticket, :confirmed)

      expected = ticket.confirmed_at.to_date.to_s

      expect(Ticket.first_confirmed_date).to eq(expected)
    end

    it 'sorted' do
      first_ticket = create(:ticket, deadline: 1)
      second_ticket = create(:ticket, deadline: 2)
      expect(Ticket.sorted).to eq([first_ticket, second_ticket])
    end

    it 'ombudsman_attendance' do
      sectoral_attendance = create(:ticket, internal_status: :sectoral_attendance)
      subnet_attendance = create(:ticket, internal_status: :subnet_attendance)
      subnet_validation = create(:ticket, internal_status: :subnet_validation)
      internal_attendance = create(:ticket, internal_status: :internal_attendance)

      expect(Ticket.ombudsman_attendance).to match_array([sectoral_attendance, subnet_attendance])
    end

    it 'from_organ' do
      child_ticket = create(:ticket, :with_parent)
      parent = child_ticket.parent
      organ = child_ticket.organ

      expect(Ticket.from_organ(organ)).to eq([child_ticket])
    end

    it 'from_security_organ' do
      organ = create(:organ, :security_organ)
      child_ticket = create(:ticket, :with_parent, organ: organ, internal_status: :sectoral_attendance)

      expect(Ticket.from_security_organ).to eq([child_ticket])
    end

    it 'from_subnet' do
      subnet = create(:subnet)
      child_ticket = create(:ticket, :with_parent, subnet: subnet, organ: subnet.organ)

      parent = child_ticket.parent

      expect(Ticket.from_subnet(subnet)).to eq([child_ticket])
    end

    it 'from_ticket_department' do
      child_ticket = create(:ticket, :with_parent)
      ticket_department = create(:ticket_department, ticket: child_ticket)

      parent = child_ticket.parent
      department = ticket_department.department

      expect(Ticket.from_ticket_department(department)).to eq([child_ticket])
    end

    it 'from_child_ticket_department' do
      child_ticket = create(:ticket, :with_parent)
      ticket_department = create(:ticket_department, ticket: child_ticket)

      parent = child_ticket.parent
      department = ticket_department.department

      expect(Ticket.parent_tickets.from_child_ticket_department(department)).to eq([parent])
    end

    it 'from_ticket_department_sub_department' do
      child_ticket = create(:ticket, :with_parent)
      ticket_department = create(:ticket_department, ticket: child_ticket)

      department = ticket_department.department
      sub_department = create(:sub_department, department: department)

      create(:ticket_department_sub_department, ticket_department: ticket_department, sub_department: sub_department)

      expect(Ticket.from_ticket_sub_department(sub_department)).to eq([child_ticket])
    end

    it 'parent_tickets' do
      child_ticket = create(:ticket, :with_parent)
      parent = child_ticket.parent

      expect(Ticket.parent_tickets).to eq([parent])
    end

    it 'leaf_tickets' do
      ticket = create(:ticket)
      child = create(:ticket, :with_parent)

      expect(Ticket.leaf_tickets).to match_array([child, ticket])
    end

    it 'child_tickets' do
      ticket = create(:ticket)
      child = create(:ticket, :with_parent)

      expect(Ticket.child_tickets).to match_array([child])
    end

    it 'public_tickets' do
      ticket = create(:ticket, :sic, public_ticket: true)
      child_ticket = create(:ticket, :with_parent, :public_ticket, parent: ticket)

      expect(Ticket.public_tickets).to eq([ticket])
    end

    it 'with_used_input' do
      ticket_phone = create(:ticket, used_input: :phone)
      create(:ticket, used_input: :facebook)
      expect(Ticket.with_used_input(:phone)).to eq([ticket_phone])
    end

    it 'with_status' do
      ticket_confirmed = create(:ticket, :confirmed)
      expect(Ticket.with_status(:confirmed)).to eq([ticket_confirmed])
    end

    it 'with_internal_status' do
      ticket_invalidated = create(:ticket, :invalidated)
      expect(Ticket.with_internal_status(:invalidated)).to eq([ticket_invalidated])
    end

    #
    # A busca é feita nos tickets "folha".
    # - se for ticket pai, deve considerar o internal_status dos filhos
    # - se for ticket sem filhos, considera o próprio internal_status
    #
    it 'leafs_with_internal_status' do
      ticket_parent = create(:ticket)
      ticket_child = create(:ticket, :with_parent, parent: ticket_parent, internal_status: :sectoral_attendance)
      ticket_without_children = create(:ticket, internal_status: :sectoral_attendance)

      create(:ticket, :with_parent)

      scope = Ticket.parent_tickets

      expect(scope.leafs_with_internal_status(:sectoral_attendance)).to match_array([ticket_parent, ticket_without_children])
    end

    it 'without_internal_status' do
      ticket_sectoral_attendance = create(:ticket, :in_sectoral_attendance)
      create(:ticket, :invalidated)

      expect(Ticket.without_internal_status(:invalidated)).to eq([ticket_sectoral_attendance])
    end

    describe 'with_sub_department' do
      it 'child classified' do
        ticket_child = create(:ticket, :with_parent)
        ticket_parent = ticket_child.parent
        sub_department = create(:sub_department)
        create(:classification, sub_department: sub_department, ticket: ticket_child)

        expect(Ticket.with_sub_department(sub_department.id)).to match_array([ticket_parent, ticket_child])
      end

      it 'parent classified' do
        ticket_without_organ = create(:ticket, :confirmed, classified: true)
        sub_department = create(:sub_department)
        create(:classification, sub_department: sub_department, ticket: ticket_without_organ)

        expect(Ticket.with_sub_department(sub_department.id)).to eq([ticket_without_organ])
      end
    end

    describe 'with_topic' do
      it 'child classified' do
        ticket_child = create(:ticket, :with_parent)
        ticket_parent = ticket_child.parent
        topic = create(:topic)
        create(:classification, topic: topic, ticket: ticket_child)

        expect(Ticket.with_topic(topic.id)).to match_array([ticket_child, ticket_parent])
      end

      it 'parent classified' do
        ticket_child = create(:ticket, :with_parent)
        ticket_parent = ticket_child.parent
        topic = create(:topic)
        create(:classification, topic: topic, ticket: ticket_parent)

        expect(Ticket.with_topic(topic.id)).to eq([ticket_parent])
      end
    end

    describe 'with_subtopic' do
      it 'child classified' do
        ticket_child = create(:ticket, :with_parent)
        ticket_parent = ticket_child.parent
        organ = ticket_child.organ
        topic = create(:topic, organ: organ)
        subtopic = create(:subtopic, topic: topic)
        create(:classification, subtopic: subtopic, ticket: ticket_child)

        expect(Ticket.with_subtopic(subtopic.id)).to match_array([ticket_child, ticket_parent])
      end

      it 'parent classified' do
        ticket_child = create(:ticket, :with_parent)
        ticket_parent = ticket_child.parent
        topic = create(:topic)
        subtopic = create(:subtopic, topic: topic)
        create(:classification, subtopic: subtopic, ticket: ticket_parent)

        expect(Ticket.with_subtopic(subtopic.id)).to eq([ticket_parent])
      end
    end

    describe 'with_budget_program' do
      it 'child classified' do
        ticket_child = create(:ticket, :with_parent)
        ticket_parent = ticket_child.parent
        budget_program = create(:budget_program)
        create(:classification, budget_program: budget_program, ticket: ticket_child)

        expect(Ticket.with_budget_program(budget_program)).to match_array([ticket_child, ticket_parent])
      end

      it 'parent classified' do
        ticket_child = create(:ticket, :with_parent)
        ticket_parent = ticket_child.parent
        budget_program = create(:budget_program)
        create(:classification, budget_program: budget_program, ticket: ticket_parent)

        expect(Ticket.with_budget_program(budget_program)).to eq([ticket_parent])
      end
    end

    describe 'with_theme' do
      it 'child classified' do
        ticket_child = create(:ticket, :with_parent)
        ticket_parent = ticket_child.parent
        theme = create(:theme)
        budget_program = create(:budget_program, theme: theme)
        create(:classification, budget_program: budget_program, ticket: ticket_child)

        expect(Ticket.with_theme(theme)).to eq([ticket_parent])
      end

      it 'parent classified' do
        ticket_child = create(:ticket, :with_parent)
        ticket_parent = ticket_child.parent
        theme = create(:theme)
        budget_program = create(:budget_program, theme: theme)
        create(:classification, budget_program: budget_program, ticket: ticket_parent)

        expect(Ticket.with_theme(theme)).to eq([ticket_parent])
      end
    end

    describe 'with_service_type' do
      it 'child classified' do
        ticket_child = create(:ticket, :with_parent)
        ticket_parent = ticket_child.parent
        service_type = create(:service_type)
        create(:classification, service_type: service_type, ticket: ticket_child)

        expect(Ticket.with_service_type(service_type)).to match_array([ticket_parent,ticket_child])
      end

      it 'parent classified' do
        ticket_child = create(:ticket, :with_parent)
        ticket_parent = ticket_child.parent
        service_type = create(:service_type)
        create(:classification, service_type: service_type, ticket: ticket_parent)

        expect(Ticket.with_service_type(service_type)).to eq([ticket_parent])
      end
    end

    it 'with_other_organs' do
      classification = create(:classification, :other_organs)
      ticket_other_organs = create(:ticket, classification: classification, unknown_classification: false)
      ticket
      expect(Ticket.with_other_organs).to eq([ticket_other_organs])
    end

    it 'without_other_organs' do
      ticket_other_organs = create(:classification, :other_organs).ticket
      ticket_without_classification = create(:ticket)
      ticket_classified = create(:classification).ticket

      scope = [ticket_without_classification, ticket_classified]

      expect(Ticket.without_other_organs).to match_array(scope)
    end

    it 'without_characteristic' do
      topic = create(:topic, :no_characteristic)

      ticket = create(:ticket)
      ticket_classified = create(:classification, topic_id: topic.id)
      scope = [ticket, ticket_classified]

      expect(Ticket.without_characteristic).not_to match_array(scope)
    end

    it 'without_organ_dpge' do
      organ_dpge = create(:executive_organ, :dpge)
      ticket_parent = create(:ticket, :with_parent, organ: organ_dpge).parent

      other_ticket = create(:ticket)

      scope = [ticket_parent, other_ticket]

      expect(Ticket.without_organ_dpge).to match_array(scope)
    end

    it 'with_answer_type' do
      ticket = create(:ticket, :answer_by_phone)
      create(:ticket, :answer_by_letter)

      expect(Ticket.with_answer_type(:phone)).to eq([ticket])
    end

    it 'with_sou_type' do
      ticket = create(:ticket, sou_type: :complaint)
      create(:ticket, sou_type: :request)

      expect(Ticket.with_sou_type(:complaint)).to eq([ticket])
    end

    it 'with_denunciation_assurance' do
      ticket = create(:ticket, denunciation_assurance: :assured)

      expect(Ticket.with_denunciation_assurance(:assured)).to eq([ticket])
    end

    it 'priority' do
      priority_ticket = create(:ticket, priority: true)
      expect(Ticket.priority).to eq([priority_ticket])
    end

    it 'sorted_comments' do
      expect(ticket.sorted_comments(:internal)).to eq(ticket.comments.where(scope: :internal).sorted)
    end

    context 'sorted_tickets' do
      let(:parent) { create(:ticket) }
      let(:first_child) { create(:ticket, :with_parent, parent: parent, confirmed_at: Date.today) }
      let(:second_child) { create(:ticket, :with_parent, parent: parent, confirmed_at: Date.today - 1.second) }

      before do
        first_child
        second_child
      end

      it { expect(parent.sorted_tickets).to eq([second_child, first_child]) }
    end

    it 'sorted_ticket_logs' do
      expect(ticket.sorted_ticket_logs).to eq(ticket.ticket_logs.sorted)
    end

    it 'not_replied status' do
      # not_replied não é um status formal. deve retornar os in_progress ou confirmed
      confirmed_ticket = create(:ticket, :confirmed)
      in_progress_ticket = create(:ticket, :in_progress)
      create(:ticket, :replied)

      expect(Ticket.not_replied).to match_array([in_progress_ticket, confirmed_ticket])
    end

    it 'not_denunciation' do
      ticket_sou = create(:ticket)
      ticket_denunciation = create(:ticket, :denunciation)
      ticket_sic = create(:ticket, :sic)

      expect(Ticket.not_denunciation).to match_array([ticket_sou, ticket_sic])
    end

    it 'active' do
      create(:ticket, internal_status: :in_filling)
      create(:ticket, :invalidated)
      create(:ticket, internal_status: :final_answer)

      create(:ticket, :confirmed)

      expect(Ticket.active.count).to eq(1)
    end

    it 'not_partial_answer' do
      create(:ticket, internal_status: :in_filling)
      create(:ticket, :invalidated)
      create(:ticket, internal_status: :final_answer)
      create(:ticket, internal_status: :partial_answer)

      expect(Ticket.not_partial_answer.count).to eq(3)
    end

    it 'not_appealed' do
      create(:ticket, internal_status: :appeal)
      create(:ticket, :invalidated)
      create(:ticket, internal_status: :final_answer)
      create(:ticket, internal_status: :partial_answer)

      expect(Ticket.not_appealed.count).to eq(3)
    end

    it 'without_partial_answer' do
      create(:answer, :with_cge_approved_partial_answer)

      ticket_partial_answer = create(:ticket, internal_status: :partial_answer)
      create(:answer, :with_cge_approved_partial_answer, ticket: ticket_partial_answer)

      ticket_cge_validation = create(:ticket, internal_status: :cge_validation)
      create(:answer, :with_cge_approved_partial_answer, ticket: ticket_cge_validation)

      ticket_with_partial_and_final_answer = create(:answer, :with_cge_approved_partial_answer).ticket
      create(:answer, ticket: ticket_with_partial_and_final_answer)

      ticket_without_answer = create(:ticket)
      ticket_with_final_answer = create(:answer).ticket

      reopened_without_partial_answer = create(:ticket, internal_status: :cge_validation, reopened: 1, reopened_at: DateTime.now)

      reopened_with_partial_answer_before_reopen = create(:ticket, internal_status: :cge_validation, reopened: 1, reopened_at: DateTime.now)
      create(:answer, :with_cge_approved_partial_answer, ticket: reopened_with_partial_answer_before_reopen, created_at: 1.day.ago)

      reopened_with_partial_answer_after_reopen = create(:ticket, internal_status: :cge_validation, reopened: 1, reopened_at: 1.day.ago)
      create(:answer, :with_cge_approved_partial_answer, ticket: reopened_with_partial_answer_after_reopen)


      expect(Ticket.without_partial_answer).to match_array([ticket_without_answer, ticket_with_final_answer, reopened_without_partial_answer, reopened_with_partial_answer_before_reopen])
    end

    it 'not_invalidated' do
      create(:ticket, internal_status: :in_filling)
      create(:ticket, :invalidated)
      create(:ticket, internal_status: :final_answer)
      create(:ticket, :confirmed)

      expect(Ticket.not_invalidated.count).to eq(3)
    end

    describe 'deadline' do
      context 'with_deadline' do
        let(:ticket_extended) do
          ticket_days = Ticket::LIMIT_TO_EXTEND_DEADLINE - 2
          in_limit = DateTime.now - ticket_days.days
          ticket = create(:ticket, :confirmed, deadline: Ticket::SOU_EXTENSION - ticket_days, confirmed_at: in_limit)
          ticket.extended = true
          ticket.save
          ticket
        end
        let(:extension) { create(:extension, status: :approved, ticket: ticket_extended) }

        it 'not_expired' do
          extension
          in_limit = DateTime.now - (Ticket::LIMIT_TO_EXTEND_DEADLINE + 1).days
          deadline_ticket = create(:ticket, :confirmed, deadline: 1, confirmed_at: in_limit)

          expect(Ticket.with_deadline(:not_expired)).to match_array([deadline_ticket, ticket_extended])
        end

        context 'expired' do
          let(:can_extend) do
            ticket_days = Ticket::LIMIT_TO_EXTEND_DEADLINE - 1
            in_limit = DateTime.now - ticket_days.days
            can_extend = create(:ticket, :confirmed, deadline: Ticket::SOU_DEADLINE - ticket_days , confirmed_at: in_limit)
            can_extend
          end

          let(:cannot_extend) do
            ticket_days = Ticket::LIMIT_TO_EXTEND_DEADLINE + 1
            exceeded_limit = DateTime.now - ticket_days.days
            cannot_extend = create(:ticket, :confirmed, deadline: Ticket::SOU_DEADLINE - ticket_days, confirmed_at: exceeded_limit)
            cannot_extend
          end

          before do
            can_extend
            extension
            ticket_extended
          end

          it 'expired_can_extend' do
            expect(Ticket.with_deadline(:expired_can_extend)).to eq([can_extend])
          end

          it 'expired' do
            expect(Ticket.with_deadline(:expired)).to match_array([cannot_extend, can_extend])
          end
        end
      end

      context 'with_ticket_department_deadline' do

        let(:ticket_without_deadline) { create(:ticket, :confirmed) }
        let(:without_deadline) { create(:ticket_department, ticket: ticket_without_deadline, deadline: nil) }

        let(:ticket_not_expired) { create(:ticket, :confirmed) }
        let(:not_expired) { create(:ticket_department, ticket: ticket_not_expired, deadline: 2) }

        let(:ticket_can_extend) { create(:ticket, :confirmed) }
        let(:can_extend) do
          ticket_days = Ticket::LIMIT_TO_EXTEND_DEADLINE - 1
          in_limit = DateTime.now - ticket_days.days
          can_extend = create(:ticket_department, ticket: ticket_can_extend, deadline: Ticket::SOU_DEADLINE - ticket_days, created_at: in_limit)
          can_extend
        end

        let(:ticket_cannot_extend) { create(:ticket, :confirmed) }
        let(:cannot_extend) do
          ticket_days = Ticket::LIMIT_TO_EXTEND_DEADLINE + 1
          exceeded_limit = DateTime.now - ticket_days.days
          cannot_extend = create(:ticket_department, ticket: ticket_cannot_extend, deadline: Ticket::SOU_DEADLINE - ticket_days, created_at: exceeded_limit)
          cannot_extend
        end

        let(:ticket_extended) do
          ticket = create(:ticket, :confirmed)
          ticket.extended = true
          ticket.save
          ticket
        end
        let(:department_extended) do
          ticket_days = Ticket::LIMIT_TO_EXTEND_DEADLINE - 2
          in_limit = DateTime.now - ticket_days.days
          department_extended = create(:ticket_department, ticket: ticket_extended, deadline: Ticket::SOU_EXTENSION - ticket_days, created_at: in_limit)
          department_extended
        end
        let(:extension) { create(:extension, status: :approved, ticket: ticket_extended) }

        before do
          without_deadline
          not_expired
          can_extend
          cannot_extend
          department_extended
        end

        it { expect(Ticket.with_ticket_department_deadline(:not_expired)).to match_array([ticket_without_deadline, ticket_not_expired, ticket_extended]) }
        it { expect(Ticket.with_ticket_department_deadline(:expired_can_extend)).to eq([ticket_can_extend]) }
        it { expect(Ticket.with_ticket_department_deadline(:expired)).to match_array([ticket_cannot_extend, ticket_can_extend]) }
      end
    end

    context 'reopened' do
      let(:ticket) { create(:ticket, :confirmed) }
      let(:child) { create(:ticket, :with_parent, parent: ticket) }
      let(:invalidated) { create(:ticket, :invalidated) }
      let(:replied) { create(:ticket, :replied) }

      let(:ticket_log_parent) { create(:ticket_log, :reopened, ticket: ticket) }
      let(:ticket_log_child) { create(:ticket_log, :reopened, ticket: child) }
      let(:ticket_log_invalidated) { create(:ticket_log, :reopened, ticket: invalidated) }
      let(:ticket_log_replied) { create(:ticket_log, :reopened, ticket: replied) }

      before do
        ticket_log_parent
        ticket_log_child
        ticket_log_invalidated
        ticket_log_replied
      end

      it { expect(Ticket.reopened).to match_array([ticket, replied]) }
    end

    context 'appealed' do
      let(:ticket) { create(:ticket, :confirmed) }
      let(:child) { create(:ticket, :with_parent, parent: ticket) }
      let(:invalidated) { create(:ticket, :invalidated) }
      let(:replied) { create(:ticket, :replied) }

      let(:ticket_log_parent) { create(:ticket_log, :appealed, ticket: ticket) }
      let(:ticket_log_child) { create(:ticket_log, :appealed, ticket: child) }
      let(:ticket_log_invalidated) { create(:ticket_log, :appealed, ticket: invalidated) }
      let(:ticket_log_replied) { create(:ticket_log, :appealed, ticket: replied) }

      before do
        ticket_log_parent
        ticket_log_child
        ticket_log_invalidated
        ticket_log_replied
      end

      it { expect(Ticket.appealed).to match_array([ticket, replied]) }
    end

    context 'reopened_at' do
      let(:ticket) { create(:ticket, :confirmed) }
      let(:child) { create(:ticket, :with_parent, parent: ticket) }
      let(:invalidated) { create(:ticket, :invalidated) }
      let(:replied) { create(:ticket, :replied) }

      let(:ticket_log_old) { create(:ticket_log, :reopened, created_at: 10.days.ago) }
      let(:ticket_log_parent) { create(:ticket_log, :reopened, ticket: ticket, created_at: created_at) }
      let(:ticket_log_child) { create(:ticket_log, :reopened, ticket: child, created_at: created_at) }
      let(:ticket_log_invalidated) { create(:ticket_log, :reopened, ticket: invalidated, created_at: created_at) }
      let(:ticket_log_replied) { create(:ticket_log, :reopened, ticket: replied, created_at: created_at) }

      let(:start_date) { 3.days.ago.to_s }
      let(:end_date) { 1.days.ago.to_s }
      let(:created_at) { 2.days.ago }

      before do
        ticket_log_old
        ticket_log_parent
        ticket_log_child
        ticket_log_invalidated
        ticket_log_replied
      end

      it { expect(Ticket.reopened_at(start_date, end_date)).to match_array([ticket, replied]) }
      it { expect(Ticket.reopened_at(start_date, nil)).to match_array([ticket, replied]) }
      it { expect(Ticket.reopened_at(nil, end_date)).to match_array([ticket_log_old.ticket, ticket, replied]) }
    end

    context 'appealed_at' do
      let(:ticket) { create(:ticket, :confirmed) }
      let(:child) { create(:ticket, :with_parent, parent: ticket) }
      let(:invalidated) { create(:ticket, :invalidated) }
      let(:replied) { create(:ticket, :replied) }

      let(:ticket_log_old) { create(:ticket_log, :appealed, created_at: 10.days.ago) }
      let(:ticket_log_parent) { create(:ticket_log, :appealed, ticket: ticket, created_at: created_at) }
      let(:ticket_log_child) { create(:ticket_log, :appealed, ticket: child, created_at: created_at) }
      let(:ticket_log_invalidated) { create(:ticket_log, :appealed, ticket: invalidated, created_at: created_at) }
      let(:ticket_log_replied) { create(:ticket_log, :appealed, ticket: replied, created_at: created_at) }

      let(:start_date) { 3.days.ago.to_s }
      let(:end_date) { 1.days.ago.to_s }
      let(:created_at) { 2.days.ago }

      before do
        ticket_log_old
        ticket_log_parent
        ticket_log_child
        ticket_log_invalidated
        ticket_log_replied
      end

      it { expect(Ticket.appealed_at(start_date, end_date)).to match_array([ticket, replied]) }
      it { expect(Ticket.appealed_at(start_date, nil)).to match_array([ticket, replied]) }
      it { expect(Ticket.appealed_at(nil, end_date)).to match_array([ticket_log_old.ticket, ticket, replied]) }
    end

    context 'with_answers_awaiting_cge_validation' do
      let(:ticket_log) { create(:ticket_log, :with_awaiting_sectoral) }
      let(:other_ticket_log) { create(:ticket_log, :with_final_answer) }

      before do
        ticket_log
        other_ticket_log
        create(:ticket)
      end

      it { expect(Ticket.with_answers_awaiting_cge_validation).to eq([ticket_log.ticket]) }
    end

    it 'with_organ' do
      child_ticket = create(:ticket, :with_parent)
      parent = child_ticket.parent
      organ = child_ticket.organ

      expect(Ticket.with_organ(organ)).to eq([parent])
    end

    context 'ticket_finished_with_other_organs' do
      let(:ticket) { create(:ticket, :confirmed, :with_classification_other_organs) }
      let(:child) { create(:ticket, :with_parent, parent: ticket) }
      let(:answer) { create( :answer, ticket: ticket) }
      let(:executive_organ) { create(:executive_organ, :dpge) }

      before do
        child
        answer
        executive_organ
      end

      it { expect(Ticket.with_ticket_finished.present?).to be true }

    end

  end
end
