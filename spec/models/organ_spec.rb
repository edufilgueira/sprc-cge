require 'rails_helper'

describe Organ do

  it_behaves_like 'models/paranoia'

  subject(:organ) { build(:organ) }

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:acronym).of_type(:string) }
      it { is_expected.to have_db_column(:name).of_type(:string) }
      it { is_expected.to have_db_column(:description).of_type(:text) }
      it { is_expected.to have_db_column(:code).of_type(:string) }
      it { is_expected.to have_db_column(:subnet).of_type(:boolean) }
      it { is_expected.to have_db_column(:ignore_cge_validation).of_type(:boolean) }
      it { is_expected.to have_db_column(:disabled_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:type).of_type(:string) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:acronym) }
      it { is_expected.to have_db_index(:code) }
      it { is_expected.to have_db_index(:subnet) }
      it { is_expected.to have_db_index(:acronym) }
      it { is_expected.to have_db_index(:type) }
    end

    describe 'associations' do
      it { is_expected.to have_many(:departments) }
      it { is_expected.to have_many(:subnets) }
      it { is_expected.to have_many(:tickets) }
      it { is_expected.to have_many(:attendance_evaluations).through(:tickets) }
      it { is_expected.to have_many(:subnet_departments).through(:subnets).source(:departments).class_name(:Department) }
    end
  end
end
