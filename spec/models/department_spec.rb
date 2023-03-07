require 'rails_helper'

describe Department do
  it_behaves_like 'models/paranoia'

  subject(:department) { build(:department) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:department, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:acronym).of_type(:string) }
      it { is_expected.to have_db_column(:name).of_type(:string) }
      it { is_expected.to have_db_column(:organ_id).of_type(:integer) }
      it { is_expected.to have_db_column(:disabled_at).of_type(:datetime) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:name) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }

    describe 'organ' do
      it { is_expected.to validate_presence_of(:organ) }
      it 'with subnet present' do
        subject.subnet = create(:subnet)
        is_expected.to_not validate_presence_of(:organ)
      end
    end

    describe 'subnet' do
      it { is_expected.to_not validate_presence_of(:subnet) }
      it 'without organ' do
        subject.organ = nil
        is_expected.to validate_presence_of(:subnet)
      end
    end

    it { is_expected.to validate_uniqueness_of(:acronym).scoped_to([:organ_id, :subnet_id]) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to([:organ_id, :subnet_id]) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:organ) }
    it { is_expected.to belong_to(:subnet) }
    it { is_expected.to have_many(:sub_departments) }
    it { is_expected.to have_many(:users) }
    it { is_expected.to have_many(:ticket_departments) }
    it { is_expected.to have_many(:tickets).through(:ticket_departments) }
  end

  describe 'nested' do
    it { is_expected.to accept_nested_attributes_for(:sub_departments).allow_destroy(true) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:name).to(:organ).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:acronym).to(:organ).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:full_acronym).to(:organ).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:name).to(:subnet).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:acronym).to(:subnet).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:full_acronym).to(:subnet).with_arguments(allow_nil: true).with_prefix }
  end

  describe 'nested' do
    it { is_expected.to accept_nested_attributes_for(:sub_departments) }
  end

  describe 'scope' do
    it 'sorted' do
      expected = Department.order('departments.acronym ASC').to_sql.downcase
      result = Department.sorted.to_sql.downcase
      expect(result).to eq(expected)
    end

    it 'sorted by organ acronym' do
      expect(Department.sorted_by_organ).to eq(Department.joins(:organ).order('organs.acronym, name'))
    end

    it 'from_orgam' do
      organ = department.organ
      department.save

      another_organ_department = create(:department)

      expect(Department.from_organ(organ)).to eq([department])
    end

    it 'create only_no_characteristic' do
      department = create(:department, name: 'NÃO SE APLICA')

      expect(Department.only_no_characteristic).to eq(department)
    end

    it 'create without_no_characteristic' do
      department = create(:department, name: 'NÃO SE APLICA')

      expect(Department.without_no_characteristic).not_to eq(department)
    end


    it_behaves_like 'models/disableable'
  end

  describe 'helpers' do
    context 'title' do
      it 'organ' do
        expected = "[#{department.organ_acronym}] #{department.acronym} - #{department.name}"
        expect(department.title).to eq(expected)
      end

      it 'subnet' do
        subnet_organ = create(:executive_organ, :with_subnet)
        subnet = create(:subnet, organ: subnet_organ)
        department_subnet = create(:department, :with_subnet, subnet: subnet)

        expected = "[#{department_subnet.subnet_acronym}] #{department_subnet.acronym} - #{department_subnet.name}"
        expect(department_subnet.title).to eq(expected)
      end
    end

    it 'short_title' do
      expected = "#{department.acronym} - #{department.name}"
      expect(department.short_title).to eq(expected)
    end

    context 'full_acronym' do
      it 'organ' do
        expected = "#{department.organ_full_acronym} - #{department.acronym}"
        expect(department.full_acronym).to eq(expected)
      end

      it 'subnet' do
        subnet_organ = create(:executive_organ, :with_subnet)
        subnet = create(:subnet, organ: subnet_organ)
        department_subnet = create(:department, :with_subnet, subnet: subnet)

        expected = "#{department_subnet.subnet_acronym} - #{department_subnet.acronym}"
        expect(department_subnet.full_acronym).to eq(expected)
      end
    end
  end

  context 'callbacks' do
    context 'before_save' do

      it 'upcase_name' do
        department = build(:department, name: 'upcase name')

        department.save

        expect(department.name).to eq('UPCASE NAME')
      end

      context 'invoke nested set_disabled_at' do
        let(:sub_department) { build(:sub_department, _disable: '1') }
        let(:department) { create(:department) }

        before do
          allow(department).to receive(:sub_departments){ [sub_department] }
          allow(sub_department).to receive(:set_disabled_at)

          department.save
        end

        it { expect(sub_department).to have_received(:set_disabled_at) }
      end
    end
  end
end
