require 'rails_helper'

describe TicketDepartment do
  it_behaves_like 'models/paranoia'

  subject(:ticket_department) { build(:ticket_department) }

  let(:organ) { ticket_department.ticket.organ }
  let(:department) { create(:department, organ: organ) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:ticket_department, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:ticket_id).of_type(:integer) }
      it { is_expected.to have_db_column(:department_id).of_type(:integer) }
      it { is_expected.to have_db_column(:description).of_type(:text) }
      it { is_expected.to have_db_column(:answer).of_type(:integer) }
      it { is_expected.to have_db_column(:note).of_type(:text) }
      it { is_expected.to have_db_column(:deadline).of_type(:integer) }
      it { is_expected.to have_db_column(:deadline_ends_at).of_type(:date) }

    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:ticket_id) }
      it { is_expected.to have_db_index(:department_id) }
    end
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:answer).with_values([:not_answered, :answered]) }
  end

  describe 'attributes' do
    it { is_expected.to respond_to(:justification) }
    it { is_expected.to respond_to(:justification=) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:ticket) }
    it { is_expected.to belong_to(:department) }
    it { is_expected.to have_many(:ticket_department_emails).inverse_of(:ticket_department).dependent(:destroy) }
    it { is_expected.to have_many(:ticket_department_sub_departments).inverse_of(:ticket_department).dependent(:destroy) }
  end

  describe 'nested' do
    it { is_expected.to accept_nested_attributes_for(:ticket_department_emails).allow_destroy(true) }
    it { is_expected.to accept_nested_attributes_for(:ticket_department_sub_departments).allow_destroy(true) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:ticket) }
    it { is_expected.to validate_presence_of(:department) }
    it { is_expected.to validate_presence_of(:description) }

    it 'department' do
      is_expected.to validate_uniqueness_of(:department_id).scoped_to(:ticket_id)
    end

    context 'justification' do
      context 'nil' do
        it { is_expected.not_to validate_presence_of(:justification) }
      end
       context 'empty' do
        before { ticket_department.justification = '' }
         it { is_expected.to be_invalid }
      end
    end

    context 'uniqueness' do
      context 'ticket_department_sub_departments' do
        let(:sub_department) { build(:sub_department, department: ticket_department.department) }

        before do
          ticket_department.ticket_department_sub_departments << build_list(:ticket_department_sub_department, 2, sub_department: sub_department)

          ticket_department.validate
        end

        it { expect(ticket_department).not_to be_valid }
        it { expect(ticket_department.errors['ticket_department_sub_departments[0].sub_department_id']).to be_present }
      end
    end
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:organ_acronym).to(:ticket) }
    it { is_expected.to delegate_method(:reopened_at).to(:ticket).with_prefix }
    it { is_expected.to delegate_method(:appeals_at).to(:ticket).with_prefix }
    it { is_expected.to delegate_method(:subnet_acronym).to(:department) }
    it { is_expected.to delegate_method(:name).to(:department).with_prefix }
    it { is_expected.to delegate_method(:acronym).to(:department).with_prefix }
  end

  describe 'helpers' do
    it 'title' do
      ticket_department = create(:ticket_department)
      expected = "[#{ticket_department.organ_acronym}] #{ticket_department.department_name}"

      expect(ticket_department.title).to eq(expected)
    end

    it 'title with subnet' do
      department = create(:department, :with_subnet)
      ticket_department = create(:ticket_department, department: department)

      expected = "[#{ticket_department.organ_acronym}] #{department.subnet_acronym} / #{ticket_department.department_name}"

      expect(ticket_department.title).to eq(expected)
    end

    context 'title_for_sectoral' do
      context 'with deadline' do
        let(:ticket_department) { create(:ticket_department) }
        let(:deadline_label) { I18n.t('ticket.deadline', count: ticket_department.deadline) }
        let(:expected) { "#{ticket_department.department_acronym} (#{deadline_label})" }

        it { expect(ticket_department.title_for_sectoral).to eq(expected) }
      end

      context 'without deadline' do
        let(:ticket_department) { create(:ticket_department, :without_deadline) }
        let(:deadline_label) { I18n.t('ticket_department.deadline.undefined') }
        let(:expected) { "#{ticket_department.department_acronym} (#{deadline_label})" }

        it { expect(ticket_department.title_for_sectoral).to eq(expected) }
      end
    end

    it 'unit' do
      ticket_department.department = department

      expect(ticket_department.unit).to eq(ticket_department.department)
    end

    it 'response_deadline' do
      ticket = create(:ticket, deadline_ends_at: Date.today + 1)
      ticket_department = create(:ticket_department, ticket: ticket, deadline_ends_at: nil)

      expected = Date.today + 1

      expect(ticket_department.response_deadline).to eq(expected)
    end

    it 'remaining_days_to_deadline' do
      ticket = create(:ticket, deadline: 5)
      ticket_department = create(:ticket_department, ticket: ticket, deadline: nil)

      expected = 5

      expect(ticket_department.remaining_days_to_deadline).to eq(expected)
    end

    context 'forward_justification' do
      let(:ticket) { create(:ticket) }
      let(:ticket_department) { create(:ticket_department, ticket: ticket) }
      let(:department) { ticket_department.department }
      let(:justification) { 'Justification from operator' }
      let(:forward_ticket_log) { create(:ticket_log, :forward, resource: department, ticket: ticket, description: justification)}

      before do
        forward_ticket_log

        create(:ticket_log, :forward, ticket: ticket)
        create(:ticket_log, resource: department, ticket: ticket)
      end

      it { expect(ticket_department.forward_justification).to eq(justification) }
    end

    context 'ticket_status_update' do
      let(:ticket_department) { create(:ticket_department, :with_ticket) }
      let(:other_ticket_department) { create(:ticket_department, :with_ticket) }
      let(:ticket) { ticket_department.ticket }

      it 'partial_answer' do
        ticket.partial_answer!

        expect(ticket_department.answer).to eq('not_answered')
      end

      it 'final_answer' do
        ticket.final_answer!
        ticket.ticket_departments.each do |ticket_department|
          expect(ticket_department.answer).to eq('answered')
        end
      end
    end
  end

  describe '#has_attribute_protected_attachment' do
    context 'when has ticket_attachment_protected' do
      context 'when attachment attribute param exist' do
        it 'return true' do
          ticket_protect_attachment = create(:ticket_protect_attachment, resource: ticket_department)
          ticket_department = ticket_protect_attachment.resource
          ticket_department.protected_attachment_ids = [ticket_protect_attachment.attachment_id]
          expect(ticket_department.has_attribute_protected_attachment(ticket_protect_attachment.attachment_id)).to eq(true)
        end
      end

      context 'when attachment attribute param is not associated' do
        it 'return false' do
          ticket_protect_attachment = create(:ticket_protect_attachment, resource: ticket_department)
          ticket_department = ticket_protect_attachment.resource
          ticket_department.protected_attachment_ids = [ticket_protect_attachment.attachment_id]
          expect(ticket_department.has_attribute_protected_attachment(ticket_protect_attachment.attachment_id + 1)).to eq(false)
        end
      end

      context 'when protected_attachment attribute not exist' do
        it 'return nil' do
          ticket_protect_attachment = create(:ticket_protect_attachment, resource: ticket_department)
          ticket_department = ticket_protect_attachment.resource
          expect(ticket_department.has_attribute_protected_attachment(ticket_protect_attachment.attachment_id + 1)).to be_nil
        end
      end
    end
  end

  describe '#create_attachment_protection' do
    context 'when has attachments making a association' do
      it 'create ticket_protect_attachment' do
        expect do
          ticket = create(:ticket)
          create(:attachment, attachmentable: ticket)
          create(:attachment, attachmentable: ticket)
          create(:ticket_department, ticket_id: ticket.id, protected_attachment_ids: ticket.attachment_ids)
        end.to change(TicketProtectAttachment, :count).by(2)
      end
    end
  end
end
