require 'rails_helper'
require 'cancan/matchers'

describe Abilities::Ticket do

  let(:ticket) { create(:ticket, :confirmed) }
  let(:another_ticket) { create(:ticket) }

  subject(:ability) { Abilities::Ticket.new(ticket) }

  # pode visualizar a senha na impressão do chamado
  it { is_expected.to be_able_to(:view_user_print_password, Ticket) }

  context 'signed in with ticket' do
    it { is_expected.to be_able_to(:show, ticket) }
    it { is_expected.to be_able_to(:history, ticket) }
    it { is_expected.to_not be_able_to(:edit, ticket) }
    it { is_expected.to_not be_able_to(:update, ticket) }
    it { is_expected.to be_able_to(:view_user_info, Ticket) }

    it { is_expected.to be_able_to(:can_view_deadline, ticket) }
  end

  context 'signed in with another ticket' do

    it { is_expected.to_not be_able_to(:show, another_ticket) }
    it { is_expected.to_not be_able_to(:history, another_ticket) }
    it { is_expected.to_not be_able_to(:edit, another_ticket) }
    it { is_expected.to_not be_able_to(:update, another_ticket) }
  end

  describe 'Answer' do
    let(:answer) { build(:answer) }
    let(:ticket_confirmed) { create(:ticket, :confirmed) }
    let(:ticket_finalized) { build(:ticket, internal_status: :final_answer, status: :replied) }

    context 'when cge_approved' do
      before { answer.status = :call_center_approved }

      it { is_expected.to be_able_to(:view, answer) }
    end

    context 'when cge_approved' do
      before { answer.status = :cge_approved }

      it { is_expected.to be_able_to(:view, answer) }
    end

    context 'when user_evaluated' do
      before { answer.status = :user_evaluated }

      it { is_expected.to be_able_to(:view, answer) }
    end

    context 'when cge_rejected' do
      before { answer.status = :cge_rejected }

      it { is_expected.to_not be_able_to(:view, answer) }
    end

    context 'when awaiting' do
      before { answer.status = :awaiting }

      it { is_expected.to_not be_able_to(:view, answer) }
    end

    context 'when sectoral_approved' do
      before { answer.status = :sectoral_approved }

      it { is_expected.to_not be_able_to(:view, answer) }
    end
  end

  describe 'Comment' do
    let(:ticket_confirmed) { create(:ticket, :confirmed) }
    let(:ticket_finalized) { build(:ticket, internal_status: :final_answer, status: :replied) }
    context 'public_comment' do
      it { is_expected.to be_able_to(:create_public_comment, ticket_confirmed) }
      it { is_expected.to_not be_able_to(:create_public_comment, ticket_finalized) }
    end
  end

  describe 'Attachment' do
    let(:attachment) { create(:attachment, attachmentable: attachmentable) }
    let(:another_attachment) { create(:attachment, attachmentable: another_attachmentable) }

    context 'from ticket' do
      let(:attachmentable) { ticket }

      let(:another_ticket) { create(:ticket) }
      let(:another_attachment) { create(:attachment, attachmentable: another_ticket) }

      it { is_expected.to be_able_to(:view, attachment) }
      it { is_expected.not_to be_able_to(:view, another_attachment) }

      it { is_expected.to be_able_to(:destroy, attachment) }
      it { is_expected.not_to be_able_to(:destroy, another_attachment) }
    end

    context 'from comment' do
      context 'internal' do
        let(:attachmentable) { create(:comment, :internal) }

        it { is_expected.not_to be_able_to(:view, attachment) }
      end

      context 'external' do
        let(:attachmentable) { create(:comment, :external, author: ticket) }
        let(:another_attachmentable) { create(:comment, :external) }

        it { is_expected.to be_able_to(:view, attachment) }
        it { is_expected.to be_able_to(:destroy, attachment) }
        it { is_expected.not_to be_able_to(:destroy, another_attachment) }
      end
    end

    context 'from answer' do
      let(:attachmentable) { create(:answer) }

      it { is_expected.to be_able_to(:view, attachment) }
      it { is_expected.not_to be_able_to(:destroy, attachment) }
    end
  end

  context 'appeal' do
    context 'sou' do
      it { is_expected.not_to be_able_to(:appeal, ticket) }
    end

    context 'sic' do
      before do
        ticket.ticket_type = :sic
        ticket.internal_status = :final_answer
        ticket.responded_at = DateTime.now
      end

      it { is_expected.to be_able_to(:appeal, ticket) }

      context 'ticket open' do
        before { ticket.sectoral_attendance! }
        it { is_expected.to_not be_able_to(:appeal, ticket) }
      end

      context 'ticket answered more than 10 days ago' do
        before { ticket.responded_at = 11.days.ago.to_datetime }

        it { is_expected.not_to be_able_to(:appeal, ticket) }
      end

      context 'ticket child' do
        let(:ticket_child) { create(:ticket, :with_parent, :sic, responded_at: Date.today, parent: ticket) }

        it { is_expected.not_to be_able_to(:appeal, ticket_child) }
      end

      context 'another user ticket' do
        before do
          another_ticket.ticket_type = :sic
          another_ticket.responded_at = DateTime.now
        end

        it { is_expected.not_to be_able_to(:appeal, another_ticket) }
      end

      context 'ticket with appeal already requested' do
        before do
          ticket.responded_at = Date.yesterday.to_datetime
          ticket.appeals_at = DateTime.now
        end

        it { is_expected.not_to be_able_to(:appeal, ticket) }
      end

      context 'ticket already appealed' do
        context 'once' do
          before { ticket.reopened = 1 }

          it { is_expected.to be_able_to(:appeal, ticket) }
        end

        context 'twice' do
          before { ticket.appeals = 2 }

          it { is_expected.not_to be_able_to(:appeal, ticket) }
        end
      end
    end
  end

  context 'reopen' do
    context 'sic' do
      let(:ticket) { create(:ticket, :replied, :sic) }
      it { is_expected.to be_able_to(:reopen, ticket) }      
    end

    context 'sou' do
      let(:ticket) { create(:ticket, :replied) }

      it { is_expected.to be_able_to(:reopen, ticket) }

      context 'ticket child' do
        let(:ticket_child) { create(:ticket, :with_parent, :replied, parent: ticket) }

        it { is_expected.to be_able_to(:reopen, ticket_child) }
      end

      context 'another user ticket' do
        before { another_ticket.responded_at = DateTime.now }

        it { is_expected.not_to be_able_to(:reopen, another_ticket) }
      end

      context 'ticket already reopened' do
        before do
          ticket.responded_at = Date.yesterday.to_datetime
          ticket.reopened_at = DateTime.now
        end

        it { is_expected.not_to be_able_to(:reopen, ticket) }
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

  describe '#can_evaluate' do
    context 'current_user' do
      let(:ticket) { ticket_child.parent }
      let(:ticket_child) { create(:ticket, :with_parent, internal_status: :final_answer) }
      let(:other_ticket) { create(:ticket, :with_parent, internal_status: :final_answer) }
      let(:answer) { create(:answer, :final, ticket: ticket_child) }
      let(:other_answer) { create(:answer, :final, ticket: other_ticket) }

      it { is_expected.to be_able_to(:evaluate, answer) }
      it { is_expected.not_to be_able_to(:evaluate, other_answer) }
      it 'partial_answer' do
        answer.partial!
        is_expected.to_not be_able_to(:evaluate, answer)
      end
    end

    context 'internal_status' do
      let(:ticket) { ticket_child.parent }
      let(:ticket_child) { create(:ticket, :with_parent) }
      let(:answer) { create(:answer, :final, ticket: ticket_child) }

      it { is_expected.not_to be_able_to(:evaluate, answer) }
    end
  end
end
