require 'rails_helper'

RSpec.describe Subnet, type: :model do
  it_behaves_like 'models/paranoia'

  subject(:subnet) { build(:subnet) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:subnet, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:acronym).of_type(:string) }
      it { is_expected.to have_db_column(:name).of_type(:string) }
      it { is_expected.to have_db_column(:organ_id).of_type(:integer) }
      it { is_expected.to have_db_column(:ignore_sectoral_validation).of_type(:boolean) }
      it { is_expected.to have_db_column(:disabled_at).of_type(:datetime) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:disabled_at) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:organ) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:organ) }
    it { is_expected.to have_many(:departments) }
    it { is_expected.to have_many(:sub_departments).through(:departments) }
    it { is_expected.to have_many(:users) }
    it { is_expected.to have_many(:tickets) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:name).to(:organ).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:acronym).to(:organ).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:full_acronym).to(:organ).with_arguments(allow_nil: true).with_prefix }
  end

  describe 'scope' do
    it 'sorted' do
      expected = Subnet.order('subnets.acronym ASC').to_sql.downcase
      result = Subnet.sorted.to_sql.downcase
      expect(result).to eq(expected)
    end

    it 'sorted by organ acronym' do
      expect(Subnet.sorted_by_organ).to eq(Subnet.joins(:organ).order('organs.acronym, name'))
    end

    it 'from_orgam' do
      organ = subnet.organ
      subnet.save

      another_organ_subnet = create(:subnet)

      expect(Subnet.from_organ(organ)).to eq([subnet])
    end

    it_behaves_like 'models/disableable'
  end

  describe 'helpers' do
    it 'title' do
      expected = "[#{subnet.acronym}] #{subnet.name}"
      expect(subnet.title).to eq(expected)
    end

    it 'full_acronym' do
      expected = "[#{subnet.organ_full_acronym}] #{subnet.acronym}"
      expect(subnet.full_acronym).to eq(expected)
    end
  end
end
