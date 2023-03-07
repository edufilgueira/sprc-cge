require 'rails_helper'

RSpec.describe TicketDepartmentSubDepartment, type: :model do
  it_behaves_like 'models/paranoia'

  subject(:ticket_department_sub_department) { build(:ticket_department_sub_department) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:ticket_department_sub_department, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:sub_department_id).of_type(:integer) }
      it { is_expected.to have_db_column(:ticket_department_id).of_type(:integer) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:ticket_department_id) }
      it { is_expected.to have_db_index(:sub_department_id) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:ticket_department) }
    it { is_expected.to belong_to(:sub_department) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:ticket_department) }
    it { is_expected.to validate_presence_of(:sub_department) }

    it 'sub_department_belongs_to_department' do
      ticket_department_sub_department.ticket_department = create(:ticket_department)
      ticket_department_sub_department.sub_department = create(:sub_department)

      expect(ticket_department_sub_department).to be_invalid
    end

    it { is_expected.to validate_uniqueness_of(:sub_department_id).scoped_to(:ticket_department_id) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:name).to(:sub_department).with_prefix }
    it { is_expected.to delegate_method(:acronym).to(:sub_department).with_prefix }
  end
end
