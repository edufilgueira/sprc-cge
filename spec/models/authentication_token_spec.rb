require 'rails_helper'

describe AuthenticationToken do

  subject(:authentication_token) { build(:authentication_token) }

  describe 'factories' do
    it { is_expected.to be_valid }
  end

  describe 'attributes' do
    describe 'columns' do
      it { is_expected.to have_db_column(:body).of_type(:string) }
      it { is_expected.to have_db_column(:last_used_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:ip_address).of_type(:string) }
      it { is_expected.to have_db_column(:user_agent).of_type(:string) }
      it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:user_id) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
