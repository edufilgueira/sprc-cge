require 'rails_helper'

describe Extension do
  it_behaves_like 'models/paranoia'

  subject(:extension) { build(:extension) }


  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:extension, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:description).of_type(:text) }
      it { is_expected.to have_db_column(:email).of_type(:string) }
      it { is_expected.to have_db_column(:status).of_type(:integer) }
      it { is_expected.to have_db_column(:ticket_id).of_type(:integer) }
      it { is_expected.to have_db_column(:ticket_department_id).of_type(:integer) }

      # Audits

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:status) }
      it { is_expected.to have_db_index(:ticket_id) }
      it { is_expected.to have_db_index(:ticket_department_id) }
    end
  end

  describe 'enums' do
    it 'status' do
      statuses = [:in_progress, :approved, :rejected, :cancelled]

      is_expected.to define_enum_for(:status).with_values(statuses)
    end
  end

  describe 'attributes' do
    it { is_expected.to respond_to(:justification) }
    it { is_expected.to respond_to(:justification=) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:status) }
  end

  describe 'validate_uniqueness' do
    context "if not in_progress" do
      before { allow(subject).to receive(:in_progress?).and_return(false) }
      it { should_not validate_uniqueness_of(:ticket_id).scoped_to([:ticket_id, :status]) }
    end
  end 

  describe 'associations' do
    it { is_expected.to belong_to(:ticket) }
    it { is_expected.to belong_to(:ticket_department) }
    it { is_expected.to have_one(:organ).through(:ticket) }
    it { is_expected.to have_many(:ticket_logs).dependent(:destroy) }
    it { is_expected.to have_many(:extension_users).dependent(:destroy) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:parent_protocol).to(:ticket).with_prefix }
    it { is_expected.to delegate_method(:acronym).to(:organ).with_prefix }
    it { is_expected.to delegate_method(:title).to(:ticket_department).with_prefix(:department) }
  end

  describe '#extend_deadline' do
    it 'sou approved' do
      extension = create(:extension, status: :approved)
      ticket = extension.ticket
      expected_deadline = Holiday.next_weekday(Ticket.response_extension(:sou), ticket.confirmed_at)
      expected_deadline_ends = ticket.confirmed_at.to_date + expected_deadline

      extension.extend_deadline

      ticket.reload
      parent = ticket.parent

      expect(parent.deadline).to eq(expected_deadline)
      expect(parent.deadline_ends_at).to eq(expected_deadline_ends)
      expect(ticket.deadline).to eq(expected_deadline)
      expect(ticket.deadline_ends_at).to eq(expected_deadline_ends)
    end

    it 'update answers deadline' do
      extension = create(:extension, status: :approved)
      ticket = extension.ticket
      ticket.deadline = -1

      answer = ticket.answers.create(
        deadline: -1, ticket_id: ticket.id,
        answer_type: :final, answer_scope: :sectoral, status: :user_evaluated,
        classification: :sou_demand_well_founded, description: 'teste 123', version: 0
      )

      extension.extend_deadline
      answer.reload
      expect(answer.deadline).to eq(-1 + Holiday.next_weekday(Ticket::response_extension_days))
      expect(answer.sectoral_deadline).to eq(-1 + Holiday.next_weekday(Ticket::response_extension_days))
    end

    context 'ensures counting' do

      context 'when not reopened' do

        it 'from ticket.corfirmed_at' do
          confirmed_at = 3.days.ago.to_date
          ticket = create(:ticket, confirmed_at: confirmed_at)
          extension = create(:extension, status: :approved, ticket: ticket)

          deadline = Holiday.next_weekday(Ticket.response_extension(:sou), confirmed_at)
          expected_deadline_ends = ticket.confirmed_at.to_date + deadline

          expected_deadline = (expected_deadline_ends - Date.today).to_i

          extension.extend_deadline
          ticket.reload

          expect(ticket.deadline).to eq(expected_deadline)
          expect(ticket.deadline_ends_at).to eq(expected_deadline_ends.to_date)
        end
      end
    end

    context 'when reopened' do
      it 'from ticket.reopened_at' do
        confirmed_at = 20.days.ago.to_date
        reopened_at = 3.days.ago.to_date
        ticket = create(:ticket, :with_reopen, confirmed_at: confirmed_at, reopened_at: reopened_at)
        extension = create(:extension, status: :approved, ticket: ticket)

        deadline = Holiday.next_weekday(Ticket.response_extension(:sou), reopened_at)
        expected_deadline_ends = ticket.reopened_at.to_date + deadline

        expected_deadline = (expected_deadline_ends - Date.today).to_i

        extension.extend_deadline
        ticket.reload

        expect(ticket.deadline).to eq(expected_deadline)
        expect(ticket.deadline_ends_at).to eq(expected_deadline_ends.to_date)
      end

      it 'from ticket_department.ticket.reopened_at' do
        created_at = 20.days.ago.to_date
        reopened_at = 3.days.ago.to_date
        ticket = create(:ticket, :with_reopen, reopened_at: reopened_at)
        ticket_department = create(:ticket_department, ticket: ticket, created_at: created_at, deadline_ends_at: ticket.deadline_ends_at)
        extension = create(:extension, ticket: ticket, ticket_department: ticket_department, status: :approved)

        deadline = Holiday.next_weekday(Ticket.response_extension(:sou), reopened_at)

        expected_deadline_ends = reopened_at + deadline
        expected_deadline = (expected_deadline_ends - Date.today).to_i

        extension.extend_deadline
        ticket_department.reload

        expect(ticket_department.deadline).to eq(expected_deadline)
        expect(ticket_department.deadline_ends_at).to eq(expected_deadline_ends.to_date)
      end
    end

    context 'when appealed' do
      it 'from ticket.appeals_at' do
        confirmed_at = 20.days.ago.to_date
        appeals_at = 3.days.ago.to_date
        ticket = create(:ticket, :with_appeal, confirmed_at: confirmed_at, appeals_at: appeals_at)
        extension = create(:extension, status: :approved, ticket: ticket)

        deadline = Holiday.next_weekday(Ticket.response_extension(:sic), appeals_at)
        expected_deadline_ends = ticket.appeals_at.to_date + deadline

        expected_deadline = (expected_deadline_ends - Date.today).to_i

        extension.extend_deadline
        ticket.reload

        expect(ticket.deadline).to eq(expected_deadline)
        expect(ticket.deadline_ends_at).to eq(expected_deadline_ends.to_date)
      end

      it 'from ticket_department.ticket.appeals_at' do
        created_at = 20.days.ago.to_date
        appeals_at = 3.days.ago.to_date
        ticket = create(:ticket, :with_appeal, appeals_at: appeals_at)
        ticket_department = create(:ticket_department, ticket: ticket, created_at: created_at, deadline_ends_at: ticket.deadline_ends_at)
        extension = create(:extension, ticket: ticket, ticket_department: ticket_department, status: :approved)

        deadline = Holiday.next_weekday(Ticket.response_extension(:sic), appeals_at)

        expected_deadline_ends = appeals_at + deadline
        expected_deadline = (expected_deadline_ends - Date.today).to_i

        extension.extend_deadline
        ticket_department.reload

        expect(ticket_department.deadline).to eq(expected_deadline)
        expect(ticket_department.deadline_ends_at).to eq(expected_deadline_ends.to_date)
      end
    end

    it 'ticket department sou approved' do
      ticket = create(:ticket, :with_parent)
      ticket_department = create(:ticket_department, ticket: ticket)
      extension = create(:extension, ticket: ticket, ticket_department: ticket_department, status: :approved)
      expected_deadline = Holiday.next_weekday(Ticket.response_extension(:sou), ticket_department.created_at)
      expected_deadline_ends = ticket.confirmed_at.to_date + expected_deadline

      extension.extend_deadline

      ticket.reload
      ticket_department.reload
      parent = ticket.parent

      expect(parent.deadline).to eq(expected_deadline)
      expect(parent.deadline_ends_at).to eq(expected_deadline_ends)
      expect(ticket.deadline).to eq(expected_deadline)
      expect(ticket.deadline_ends_at).to eq(expected_deadline_ends)
      expect(ticket_department.deadline).to eq(expected_deadline)
      expect(ticket_department.deadline_ends_at).to eq(expected_deadline_ends)
    end

    it 'sic approved' do
      ticket = create(:ticket, :confirmed, :sic)
      extension = create(:extension, ticket: ticket, status: :approved)
      expected_deadline = Holiday.next_weekday(Ticket.response_extension(:sic), ticket.confirmed_at)
      expected_deadline_ends = ticket.confirmed_at.to_date + expected_deadline

      extension.extend_deadline

      expect(ticket.deadline).to eq(expected_deadline)
      expect(ticket.deadline_ends_at).to eq(expected_deadline_ends)
    end

    it 'sou rejected' do
      extension = create(:extension, status: :rejected)
      ticket = extension.ticket
      expected_deadline = ticket.deadline
      expected_deadline_ends = ticket.deadline_ends_at

      extension.extend_deadline

      expect(ticket.deadline).to eq(expected_deadline)
      expect(ticket.deadline_ends_at).to eq(expected_deadline_ends)
    end

    context 'on second extension' do
      context 'when extension not approved' do
        it 'not updated deadline' do
          ticket_with_extension = create(:ticket, :with_extension)
          expected_deadline = ticket_with_extension.deadline
          expected_deadline_ends = ticket_with_extension.deadline_ends_at
          extension = create(:extension, ticket: ticket_with_extension, status: :in_progress, solicitation: 2)
          extension.extend_deadline
          ticket_with_extension.reload

          expect(ticket_with_extension.deadline).to eq(expected_deadline)
          expect(ticket_with_extension.deadline_ends_at).to eq(expected_deadline_ends)
        end
      end

      context 'when extension approved' do
        it 'deadline updated' do
          ticket_with_extension = create(:ticket, :with_extension)

          expected_deadline = ticket_with_extension.deadline
          expected_deadline_ends = ticket_with_extension.deadline_ends_at
          extension = create(:extension, ticket: ticket_with_extension, status: :approved, solicitation: 2)

          # Necessario para atualizar a quantidade de dias possiveis para prorrogacao
          ticket_with_extension.reload
          days_count = extension.weekday(ticket_with_extension)
          extension.extend_deadline
          ticket_with_extension.reload

          expect(ticket_with_extension.deadline).to eq((ticket_with_extension.deadline_ends_at - Date.today).to_i)
          expect(ticket_with_extension.deadline_ends_at).to eq(expected_deadline_ends + days_count.days)
        end
      end
    end
  end

  describe 'helpers' do
    it 'status_str' do
      extension.status = :approved

      expected = Extension.human_attribute_name("status.approved")
      expect(extension.status_str).to eq(expected)
    end

    describe 'requester_name' do
      it 'organ' do
        extension = build(:extension)
        expected = extension.organ_acronym

        expect(extension.requester_name).to eq(expected)
      end

      it 'department' do
        ticket_department = build(:ticket_department)
        extension = build(:extension, ticket_department: ticket_department)
        expected = extension.department_title

        expect(extension.requester_name).to eq(expected)
      end
    end
  end

  describe 'callbacks' do
    describe 'after_save' do
      describe '#update_ticket_extended' do
        context 'when approved changes for all tickets' do
          it 'parent ticket is extended' do
            extension = create(:extension)
            parent = extension.ticket.parent
            create(:ticket, :with_parent, parent: parent)
            extension.approved!

            expect(parent.extended).to eq(true)
          end

          it 'all related ticket extended' do
            extension = create(:extension)
            parent = extension.ticket.parent
            create(:ticket, :with_parent, parent: parent)
            extension.approved!

            expect(parent.tickets.all?(&:extended)).to eq(true)
          end
        end

        context 'when not approved' do
          it 'ticket not extended' do
            extension = create(:extension)
            expect(extension.ticket.extended).to eq(false)
          end
        end
      end
    end
  end
end
