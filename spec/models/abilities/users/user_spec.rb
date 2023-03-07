require 'rails_helper'
require 'cancan/matchers'

describe Abilities::Users::User do

  let(:user) { create(:user, :user) }

  subject(:ability) { Abilities::Users::User.new(user) }


  let(:another_user) { create(:user, :user) }

  # pode editar ele mesmo
  it { is_expected.to be_able_to(:edit, user) }

  # pode atualizar ele mesmo
  it { is_expected.to be_able_to(:update, user) }

  # não pode gerenciar outros usuários
  it { is_expected.not_to be_able_to(:manage, create(:user)) }

  # não pode criar usuários
  it { is_expected.not_to be_able_to(:create, User.new) }

  it { is_expected.to be_able_to(:view_user_info, Ticket) }

  # Não pode gerar relatório
  it { is_expected.not_to be_able_to(:create, TicketReport) }

  # pode visualizar a senha na impressão do chamado
  it { is_expected.to be_able_to(:view_user_print_password, Ticket) }

  describe 'ticket' do
    let(:user_ticket) { create(:ticket, created_by: user) }
    let(:another_user_ticket) { create(:ticket, created_by: another_user) }

    let(:ticket_inactive) { create(:ticket, :in_progress, created_by: user) }
    let(:ticket_active) { create(:ticket, :confirmed, created_by: user) }

    # pode criar chamados
    it { is_expected.to be_able_to(:create, Ticket) }

    # pode gerenciar seus chamados
    it { is_expected.to_not be_able_to(:edit, user_ticket) }
    it { is_expected.to_not be_able_to(:update, user_ticket) }
    it { is_expected.to be_able_to(:read, user_ticket) }
    it { is_expected.to be_able_to(:history, user_ticket) }
    it { is_expected.to_not be_able_to(:destroy, user_ticket) }

    # não pode gerenciar chamados de outros usuários
    it { is_expected.not_to be_able_to(:edit, another_user_ticket) }
    it { is_expected.not_to be_able_to(:update, another_user_ticket) }
    it { is_expected.not_to be_able_to(:read, another_user_ticket) }
    it { is_expected.not_to be_able_to(:history, another_user_ticket) }
    it { is_expected.not_to be_able_to(:destroy, another_user_ticket) }

    it { is_expected.not_to be_able_to(:can_view_deadline, ticket_inactive) }
    it { is_expected.to be_able_to(:can_view_deadline, ticket_active) }

    context 'appeal' do
      context 'sou' do
        it { is_expected.not_to be_able_to(:appeal, user_ticket) }
      end

      context 'sic' do
        before do
          user_ticket.ticket_type = :sic
          user_ticket.internal_status = :final_answer
          user_ticket.responded_at = DateTime.now
        end

        it { is_expected.to be_able_to(:appeal, user_ticket) }

        context 'ticket open' do
          before { user_ticket.sectoral_attendance! }
          it { is_expected.to_not be_able_to(:appeal, user_ticket) }
        end

        context 'ticket answered more than 10 days ago' do
          before { user_ticket.responded_at = 11.days.ago.to_datetime }

          it { is_expected.not_to be_able_to(:appeal, user_ticket) }
        end

        context 'ticket child' do
          let(:ticket_child) { create(:ticket, :with_parent, :sic, responded_at: DateTime.now, created_by: user) }

          it { is_expected.not_to be_able_to(:appeal, ticket_child) }
        end

        context 'another user ticket' do
          before do
            another_user_ticket.ticket_type = :sic
            another_user_ticket.responded_at = DateTime.now
          end

          it { is_expected.not_to be_able_to(:appeal, another_user_ticket) }
        end

        context 'ticket with appeal already requested' do
          before do
            user_ticket.responded_at = Date.yesterday.to_datetime
            user_ticket.appeals_at = DateTime.now
          end

          it { is_expected.not_to be_able_to(:appeal, user_ticket) }
        end
      end
    end

    context 'reopen' do
      context 'sic' do
        let(:user_ticket) { create(:ticket, :sic, :replied, created_by: user) }
        it { is_expected.to be_able_to(:reopen, user_ticket) }

        context 'with appeal' do
          let(:parent) { create(:ticket, :sic, :replied, appeals: 1) }
          let(:user_ticket) { create(:ticket, :sic, :with_parent_sic, :replied, created_by: user, parent: parent) }

          it { is_expected.to_not be_able_to(:reopen, user_ticket) }
        end
      end

      context 'sou' do
        let(:user_ticket) { create(:ticket, :replied, created_by: user) }

        it { is_expected.to be_able_to(:reopen, user_ticket) }

        context 'ticket child' do
          let(:ticket_child) { create(:ticket, :with_parent, :replied, created_by: user) }

          it { is_expected.to be_able_to(:reopen, ticket_child) }
        end

        context 'ticket created by operator' do
          let(:operator) { create(:user, :operator_cge) }
          let(:ticket_child) { create(:ticket, :with_parent, :replied, created_by: nil) }

          it { is_expected.to be_able_to(:reopen, ticket_child) }
        end

        context 'another user ticket' do
          before { another_user_ticket.responded_at = DateTime.now }

          it { is_expected.not_to be_able_to(:reopen, another_user_ticket) }
        end

        context 'ticket already reopened' do
          before do
            user_ticket.responded_at = Date.yesterday.to_datetime
            user_ticket.reopened_at = DateTime.now
          end

          it { is_expected.not_to be_able_to(:reopen, user_ticket) }
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

    context 'publish ticket' do
      context 'other user ticket' do
        let(:another_user_ticket) { create(:ticket, :with_classification, created_by: another_user) }

        before { another_user_ticket.public_ticket = true }

        it { is_expected.not_to be_able_to(:publish_ticket, another_user_ticket) }
      end

      context 'denunciation' do
        let(:user_ticket) { create(:ticket, :with_classification, :denunciation, created_by: user) }

        before { user_ticket.public_ticket = true }

        it { is_expected.not_to be_able_to(:publish_ticket, user_ticket) }
      end

      context 'anonymous' do
        let(:user_ticket) { create(:ticket, :with_classification, :anonymous, created_by: user) }

        before { user_ticket.public_ticket = true }

        it { is_expected.not_to be_able_to(:publish_ticket, user_ticket) }
      end
    end
  end

  describe 'Answer' do
    let(:answer) { build(:answer) }

    context 'when awaiting' do
      before { answer.status = :awaiting }

      it { is_expected.to_not be_able_to(:view, answer) }
    end

    context 'when sectoral_rejected' do
      before { answer.status = :sectoral_rejected }

      it { is_expected.to_not be_able_to(:view, answer) }
    end

    context 'when sectoral_approved' do
      before { answer.status = :sectoral_approved }

      it { is_expected.to_not be_able_to(:view, answer) }
    end

    context 'when cge_rejected' do
      before { answer.status = :cge_rejected }

      it { is_expected.to_not be_able_to(:view, answer) }
    end

    context 'when cge_approved' do
      before { answer.status = :cge_approved }

      it { is_expected.to be_able_to(:view, answer) }
    end

    context 'when user_evaluated' do
      before { answer.status = :user_evaluated }

      it { is_expected.to be_able_to(:view, answer) }
    end

    context 'when call_center_approved' do
      before { answer.status = :call_center_approved }

      it { is_expected.to be_able_to(:view, answer) }
    end
  end

  describe 'Comment' do
    let(:ticket_confirmed) { create(:ticket, :confirmed) }
    let(:ticket_finalized) { build(:ticket, internal_status: :final_answer, status: :replied) }

    context 'public_comment' do
      it { is_expected.to be_able_to(:create_public_comment, ticket_confirmed) }
      it { is_expected.to_not be_able_to(:create_public_comment, ticket_finalized) }
    end

    context 'internal' do
      let(:comment) { create(:comment, :internal) }

      it { is_expected.to_not be_able_to(:view, comment) }
    end
  end

  describe 'Attachment' do
    let(:attachment) { create(:attachment, attachmentable: attachmentable) }
    let(:another_attachment) { create(:attachment, attachmentable: another_attachmentable) }

    context 'from ticket' do
      let(:attachmentable) { create(:ticket, created_by: user) }

      let(:another_ticket) { create(:ticket) }
      let(:another_attachment) { create(:attachment, attachmentable: another_ticket) }

      it { is_expected.to be_able_to(:view, attachment) }
      it { is_expected.not_to be_able_to(:view, another_attachment) }
    end

    context 'from comment' do
      context 'internal' do
        let(:attachmentable) { create(:comment, :internal) }

        it { is_expected.not_to be_able_to(:view, attachment) }
      end

      context 'external' do
        let(:attachmentable) { create(:comment, :external, author: user) }
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

  context 'view denunciation' do
    context 'ticket created by user' do
      let(:denunciation_ticket) { create(:ticket, :denunciation, created_by: user) }

      # usuário criador da manifestação pode visualizar a denúncia
      it { is_expected.to be_able_to(:view_denunciation, denunciation_ticket) }
    end
  end

  describe 'Answer type option' do
    context 'answer option with letter' do
      it { is_expected.not_to be_able_to(:answer_by_letter, user) }
    end
    context 'answer option with phone' do
      it { is_expected.not_to be_able_to(:answer_by_phone, user) }
    end
  end

  describe 'Operator SouEvaluationSamples' do
    it { is_expected.not_to be_able_to(:manage, Operator::SouEvaluationSample) }
  end

  describe 'Operator SouEvaluationSamples GeneratedList' do
    it { is_expected.not_to be_able_to(:manage, Operator::SouEvaluationSamples::GeneratedList) }
  end
end