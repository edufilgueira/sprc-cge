require 'rails_helper'

describe TicketLog do
  subject(:ticket_log) { build(:ticket_log) }

  describe 'factories' do
    it { is_expected.to be_valid }
    it { expect(build(:ticket_log, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:ticket_id).of_type(:integer) }
      it { is_expected.to have_db_column(:responsible_id).of_type(:integer) }
      it { is_expected.to have_db_column(:responsible_type).of_type(:string) }
      it { is_expected.to have_db_column(:resource_id).of_type(:integer) }
      it { is_expected.to have_db_column(:resource_type).of_type(:string) }
      it { is_expected.to have_db_column(:action).of_type(:integer) }
      it { is_expected.to have_db_column(:description).of_type(:text) }
      it { is_expected.to have_db_column(:data).of_type(:text) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index([:responsible_type, :responsible_id]) }
      it { is_expected.to have_db_index([:resource_type, :resource_id]) }
      it { is_expected.to have_db_index(:ticket_id) }
    end

    describe 'callbacks' do
      context 'after_create' do
        context 'public_ticket notifier' do
          let(:service) { double }
          let(:public_ticket) { create(:ticket, :public_ticket) }

          before do
            allow(PublicTicketNotificationService).to receive(:delay) { service }
            allow(service).to receive(:call)
          end

          context 'do not call when' do
            it 'ticket is not published' do
              create(:ticket_log)

              expect(service).not_to have_received(:call)
            end

            it 'ticket_log is confirm' do
              create(:ticket_log, action: :confirm, ticket: public_ticket)

              expect(service).not_to have_received(:call)
            end

            it 'ticket_log is evaluation' do
              create(:ticket_log, action: :evaluation, ticket: public_ticket)

              expect(service).not_to have_received(:call)
            end

            it 'ticket_log is attendance_response' do
              create(:ticket_log, action: :attendance_response, ticket: public_ticket)

              expect(service).not_to have_received(:call)
            end
          end

          it 'call when published ticket' do
            ticket_log = create(:ticket_log, ticket: public_ticket)

            expect(service).to have_received(:call).with(ticket_log.id, ticket_log.action)
          end
        end
      end
    end
  end

  describe 'enums' do
    it 'action' do
      action_types = [
        :confirm,
        :comment,
        :share,
        :transfer,
        :invalidate,
        :forward,
        :evaluation,
        :reopen,
        :extension,
        :occurrence,
        :appeal,
        :change_sou_type,
        :change_ticket_type,
        :attendance_response,
        :answer,
        :create_classification,
        :update_classification,
        :create_attachment,
        :destroy_attachment,
        :edit_department_deadline,
        :attendance_finalized,
        :priority,
        :attendance_updated,
        :answer_updated,
        :answer_cge_approved,
        :answer_cge_rejected,
        :delete_share,
        :change_answer_certificate,
        :update_ticket,
        :delete_forward,
        :change_denunciation_type,
        :edit_ticket_description,
        :ticket_protect_attachment,
        :pseudo_reopen,
        :create_sou_evaluation_sample,
        :create_average_internal_evaluation,
        :update_average_internal_evaluation
      ]

      is_expected.to define_enum_for(:action).with_values(action_types)
    end
  end

  describe 'serializers' do
    it { expect(ticket_log.data).to eq({}) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:ticket) }
    it { is_expected.to validate_presence_of(:responsible) }

    context 'action' do

      it { is_expected.to validate_presence_of(:action) }

      context 'reopen' do
        before { ticket_log.action = :reopen }

        it { is_expected.to validate_presence_of(:description) }
      end

      context 'appeal' do
        before { ticket_log.action = :appeal }

        it { is_expected.to validate_presence_of(:description) }
      end

      context 'others' do
        before { ticket_log.action = :confirm }

        it { is_expected.not_to validate_presence_of(:description) }
      end
    end
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:title).to(:target_ticket).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:responsible).with_arguments(allow_nil: true).with_prefix }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:ticket) }
    it { is_expected.to belong_to(:responsible) }
    it { is_expected.to belong_to(:resource) }
    it { is_expected.to belong_to(:comment) }
    it { is_expected.to belong_to(:answer) }
  end

  describe 'scopes' do
    it 'sorted' do
      expect(TicketLog.sorted).to eq(TicketLog.order(created_at: :asc, id: :asc))
    end
  end

  describe 'helpers' do
    let(:ticket_log) { create(:ticket_log, action: :invalidate) }

    it 'target_ticket' do
      # algumas actions (change_sou_type) são executadas no ticket filhos
      # mas são registradas no ticket pai. nesses casos, o ticket filho é
      # armazenado em data[:target_ticket_id] para que tenhamos referência
      # de onde foi alterado.

      ticket = ticket_log.ticket

      ticket_log.data[:target_ticket_id] = ticket.id

      expect(ticket_log.target_ticket).to eq(ticket)
    end
  end
end
