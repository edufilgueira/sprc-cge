require 'rails_helper'

describe Occurrence do
  it_behaves_like 'models/paranoia'

  subject(:occurence) { build(:occurrence) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:occurrence, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:description).of_type(:text) }
      it { is_expected.to have_db_column(:attendance_id).of_type(:integer) }
      it { is_expected.to have_db_column(:created_by_id).of_type(:integer) }

      # Audits

      it { is_expected.to have_db_column(:deleted_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:attendance_id) }
      it { is_expected.to have_db_index(:created_by_id) }
      it { is_expected.to have_db_index(:deleted_at) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:description) }
  end


  describe 'associations' do
    it { is_expected.to belong_to(:attendance) }
    it { is_expected.to belong_to(:created_by).class_name('User') }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:title).to(:created_by).with_prefix }
  end
end
