require 'rails_helper'

describe AttendanceOrganSubnet do
  let(:attendance) { create(:attendance) }
  let(:organ) { create(:executive_organ)  }
  let(:subnet) { create(:subnet) }

  subject(:attendance_organ_subnet) { build(:attendance_organ_subnet, attendance: attendance, organ: organ, subnet: subnet) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:attendance_organ_subnet, :invalid)).to be_invalid }
  end

  describe 'db' do
    context 'columns' do
      it { is_expected.to have_db_column(:attendance_id).of_type(:integer) }
      it { is_expected.to have_db_column(:organ_id).of_type(:integer) }
      it { is_expected.to have_db_column(:subnet_id).of_type(:integer) }
      it { is_expected.to have_db_column(:unknown_subnet).of_type(:boolean) }
    end

    context 'indexes' do
      it { is_expected.to have_db_index(:attendance_id) }
      it { is_expected.to have_db_index(:organ_id) }
      it { is_expected.to have_db_index(:subnet_id) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:attendance) }
    it { is_expected.to belong_to(:organ) }
    it { is_expected.to belong_to(:subnet) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:full_acronym).to(:subnet).with_prefix }
    it { is_expected.to delegate_method(:full_title).to(:organ).with_prefix }
    it { is_expected.to delegate_method(:subnet?).to(:organ).with_prefix }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:attendance) }
    it { is_expected.to validate_presence_of(:organ) }
    it { is_expected.to validate_uniqueness_of(:attendance_id).scoped_to([:organ_id, :subnet_id]) }

    context 'subnet' do
      it { is_expected.not_to validate_presence_of(:subnet) }

      context 'when organ subnet' do
        let(:organ) { create(:executive_organ, :with_subnet) }

        context 'when unknown_subnet == false' do
          before { attendance_organ_subnet.unknown_subnet = false }

          it { is_expected.to validate_presence_of(:subnet) }
        end

        context 'when unknown_subnet == true' do
          before { attendance_organ_subnet.unknown_subnet = true }

          it { is_expected.not_to validate_presence_of(:subnet) }
        end
      end
    end
  end
end
