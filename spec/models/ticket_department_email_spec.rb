require 'rails_helper'

describe TicketDepartmentEmail do
  it_behaves_like 'models/paranoia'
  subject(:ticket_department_email) { build(:ticket_department_email) }


  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:ticket_department_email, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:ticket_department_id).of_type(:integer) }
      it { is_expected.to have_db_column(:email).of_type(:string) }
      it { is_expected.to have_db_column(:token).of_type(:string) }
      it { is_expected.to have_db_column(:active).of_type(:boolean).with_options(default: true) }
      it { is_expected.to have_db_column(:answer_id).of_type(:integer) }

      # Audits

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:ticket_department_id) }
      it { is_expected.to have_db_index(:token) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:ticket_department) }

    describe 'email' do
      context 'allowed' do
        it { is_expected.to allow_value("admin@example.com").for(:email) }
        it { is_expected.to allow_value("admin@example.br").for(:email) }
      end

      context 'denied' do
        it { is_expected.to_not allow_value("admin@example").for(:email) }
        it { is_expected.to_not allow_value("admin@").for(:email) }
        it { is_expected.to_not allow_value("admin").for(:email) }
        it { is_expected.to_not allow_value("@example").for(:email) }
        it { is_expected.to_not allow_value("@example.com").for(:email) }
        it { is_expected.to_not allow_value("@example.com.br").for(:email) }
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:ticket_department) }
    it { is_expected.to belong_to(:answer).dependent(:destroy) }
    it { is_expected.to have_many(:ticket_logs).dependent(:destroy) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:description).to(:answer).with_prefix }
    it { is_expected.to delegate_method(:department).to(:ticket_department) }
  end

  describe 'nested' do
    it { is_expected.to accept_nested_attributes_for(:answer) }
  end

  describe 'callbacks' do
    context 'on create' do
      it 'create token' do
        ticket_department_email.token = nil
        ticket_department_email.save
        expect(ticket_department_email.token).to_not be_nil
      end
    end
  end

  describe 'mailboxer' do
    context 'email' do
      it { expect(ticket_department_email.mailboxer_email(nil)).to eq(ticket_department_email.email) }
    end
  end

  describe 'helpers' do
    it 'title' do
      expect(ticket_department_email.title).to eq(ticket_department_email.email)
    end
  end
end
