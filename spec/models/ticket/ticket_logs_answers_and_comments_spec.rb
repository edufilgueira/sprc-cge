require 'rails_helper'

describe Ticket::TicketLogsAnswersAndComments do

  subject(:ticket) { build(:ticket) }

  describe 'associations' do
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:answers).dependent(:destroy) }
    it { is_expected.to have_many(:ticket_logs).dependent(:destroy) }
    it { is_expected.to have_many(:ticket_log_comments).through(:ticket_logs).source(:resource) }
    it { is_expected.to have_many(:ticket_log_answers).through(:ticket_logs).source(:resource) }
    it { is_expected.to have_many(:answer_attachments).through(:answers).source(:attachments) }
    it { is_expected.to have_many(:citizen_comments).dependent(:destroy) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:answers).to(:parent).with_arguments(allow_nil: true).with_prefix }
  end

  describe 'nested' do
    it { is_expected.to accept_nested_attributes_for(:answers) }
    it { is_expected.to accept_nested_attributes_for(:attachments).allow_destroy(true) }
    it { is_expected.to accept_nested_attributes_for(:tickets) }
    it { is_expected.to accept_nested_attributes_for(:ticket_departments) }
    it { is_expected.to accept_nested_attributes_for(:classification) }
  end

  describe 'helpers' do
    it 'sorted_ticket_logs_for_user' do
      answer_awaiting = create(:answer, :awaiting_department, ticket: ticket)
      answer_cge_approved = create(:answer, :cge_approved, ticket: ticket)
      ticket_log_forward = create(:ticket_log, :forward, ticket: ticket)
      ticket_log_awaiting = create(:ticket_log, :answer, ticket: ticket, resource: answer_awaiting)
      ticket_log_cge_approved = create(:ticket_log, :answer, ticket: ticket, resource: answer_cge_approved)
      ticket_log_without_answer = create(:ticket_log, :confirm, ticket: ticket)
      create(:ticket_log, action: :pseudo_reopen, ticket: ticket)
      expect(ticket.sorted_ticket_logs_for_user).to eq([ticket_log_forward, ticket_log_cge_approved, ticket_log_without_answer])
    end

    it 'sorted_ticket_logs_for_operator' do
      answer_awaiting = create(:answer, :awaiting_department, ticket: ticket)
      answer_cge_approved = create(:answer, :cge_approved, ticket: ticket)
      ticket_log_forward = create(:ticket_log, :forward, ticket: ticket)
      ticket_log_awaiting = create(:ticket_log, :answer, ticket: ticket, resource: answer_awaiting)
      ticket_log_cge_approved = create(:ticket_log, :answer, ticket: ticket, resource: answer_cge_approved)
      ticket_log_without_answer = create(:ticket_log, :confirm, ticket: ticket)
      create(:ticket_log, action: :pseudo_reopen, ticket: ticket)
      expect(ticket.sorted_ticket_logs_for_operator).to eq(
        [ticket_log_forward, ticket_log_awaiting, ticket_log_cge_approved, ticket_log_without_answer]
      )
    end

    context 'public_comments' do
      let(:ticket_child) { create(:ticket, :with_parent) }
      let(:ticket_parent) { ticket_child.parent }

      let(:comment_internal) { create(:comment, :internal, commentable: ticket_child) }
      let(:comment_external) { create(:comment, :external, commentable: ticket_child) }

      let(:ticket_log_child_internal) { create(:ticket_log, ticket: ticket_child, action: :comment, resource: comment_internal) }
      let(:ticket_log_parent_internal) { create(:ticket_log, ticket: ticket_parent, action: :comment, resource: comment_internal) }

      let(:ticket_log_child_external) { create(:ticket_log, ticket: ticket_child, action: :comment, resource: comment_external) }
      let(:ticket_log_parent_external) { create(:ticket_log, ticket: ticket_parent, action: :comment, resource: comment_external) }



      before do
        ticket_log_child_internal
        ticket_log_parent_internal
        ticket_log_child_external
        ticket_log_parent_external
      end

      it { expect(ticket_parent.public_comments).to eq([comment_external]) }
      it { expect(ticket_child.public_comments).to eq([comment_external]) }
    end

    describe 'final_answers' do
      let(:parent) { create(:ticket) }
      let(:ticket) { create(:ticket, :with_parent, parent: parent) }
      let(:other_ticket) { create(:ticket, :with_parent, parent: parent) }

      let(:answer_sectoral_approved) { create(:answer, :sectoral_approved, ticket: ticket) }
      let(:answer_cge_approved) { create(:answer, :with_cge_approved_final_answer, ticket: ticket) }
      let(:answer_awaiting) { create(:answer, status: :awaiting, answer_type: :final, ticket: ticket) }


      let(:ticket_log_sectoral_approved) { create(:ticket_log, :with_final_answer, ticket: parent, resource: answer_sectoral_approved) }
      let(:ticket_log_cge_approved) { create(:ticket_log, :with_final_answer, ticket: parent, resource: answer_cge_approved) }
      let(:ticket_log_awaiting) { create(:ticket_log, :with_final_answer, ticket: parent, resource: answer_awaiting) }

      let(:answer_sectoral_approved_from_other_ticket) { create(:answer, :sectoral_approved, ticket: other_ticket) }
      let(:ticket_log_sectoral_approved_from_other_ticket) { create(:ticket_log, :with_final_answer, ticket: other_ticket, resource: answer_sectoral_approved_from_other_ticket) }

      before do
        ticket_log_sectoral_approved
        ticket_log_cge_approved
        ticket_log_awaiting
        ticket_log_sectoral_approved_from_other_ticket
      end

      context 'operators answer' do
        let(:scope) do
          [
            ticket_log_sectoral_approved,
            ticket_log_cge_approved
          ]
        end


        it { expect(ticket.final_answers_to_operators).to match_array(scope) }
      end

      context 'users' do
        let(:scope) do
          [
            ticket_log_sectoral_approved,
            ticket_log_cge_approved
          ]
        end

        it { expect(parent.final_answers_to_users).to match_array(scope) }
      end

      context 'awaiting' do
        let(:scope) do
          [
            ticket_log_awaiting,
            other_ticket_log
          ]
        end

        let(:other_answer) { create(:answer, status: :awaiting, answer_type: :final, ticket: ticket) }
        let(:other_ticket_log) { create(:ticket_log, :with_final_answer, resource: other_answer, ticket: parent) }

        it { expect(parent.final_answers_awaiting).to match_array(scope) }
      end
    end
  end
end
