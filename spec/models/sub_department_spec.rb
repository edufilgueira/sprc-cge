require 'rails_helper'

describe SubDepartment do
  it_behaves_like 'models/paranoia'
  it_behaves_like 'models/disableable'

  subject(:sub_department) { build(:sub_department) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:sub_department, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:acronym).of_type(:string) }
      it { is_expected.to have_db_column(:name).of_type(:string) }
      it { is_expected.to have_db_column(:department_id).of_type(:integer) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'index' do
      it { is_expected.to have_db_index(:name) }
    end
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:acronym).to(:department).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:organ_acronym).to(:department).with_arguments(allow_nil: true).with_prefix }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:acronym) }
    it { is_expected.to validate_presence_of(:department) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:department) }
    it { is_expected.to have_many(:users) }
    it { is_expected.to have_many(:ticket_department_sub_departments) }
    it { is_expected.to have_many(:ticket_departments).through(:ticket_department_sub_departments) }
    it { is_expected.to have_many(:tickets).through(:ticket_departments) }
  end

  describe 'scope' do
    it 'sorted' do
      expect(SubDepartment.sorted).to eq(SubDepartment.order(:acronym))
    end
  end

  describe 'helpers' do
    it 'title' do
      expected = "#{sub_department.acronym} - #{sub_department.name}"
      expect(sub_department.title).to eq(expected)
    end
  end

  context 'callbacks' do
    context 'before_save' do
      it 'upcase_name' do
        sub_department = build(:sub_department, name: 'upcase name')

        sub_department.save

        expect(sub_department.name).to eq('UPCASE NAME')
      end
    end
  end
end
