require 'rails_helper'

describe ExtensionUser do

  subject(:extension_user) { build(:extension_user) }


  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:extension_user, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:user_id).of_type(:integer) }
      it { is_expected.to have_db_column(:extension_id).of_type(:integer) }
      it { is_expected.to have_db_column(:token).of_type(:string) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:user_id) }
      it { is_expected.to have_db_index(:extension_id) }
      it { is_expected.to have_db_index(:token) }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of(:extension) }
      it { is_expected.to validate_presence_of(:user) }
    end

    describe 'associations' do
      it { is_expected.to belong_to(:extension) }
      it { is_expected.to belong_to(:user) }
    end
  end

  describe 'helpers' do
    it 'create token' do
      extension_user.token = nil
      extension_user.save
      expect(extension_user.token).to_not be_nil
    end
  end
end
