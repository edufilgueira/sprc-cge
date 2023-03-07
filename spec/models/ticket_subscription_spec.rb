require 'rails_helper'

describe TicketSubscription do
  subject(:ticket_subscription) { build(:ticket_subscription) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:ticket_subscription, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:ticket_id).of_type(:integer) }
      it { is_expected.to have_db_column(:user_id).of_type(:integer) }

      it { is_expected.to have_db_column(:confirmed_email).of_type(:boolean).with_options(defult: false) }
      it { is_expected.to have_db_column(:token).of_type(:string) }
      it { is_expected.to have_db_column(:email).of_type(:string) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:ticket_id) }
      it { is_expected.to have_db_index(:user_id) }
      it { is_expected.to have_db_index(:email) }
      it { is_expected.to have_db_index(:token) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:ticket) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    context 'presence' do
      it { is_expected.to validate_presence_of(:ticket) }
      it { is_expected.to validate_presence_of(:email) }
    end

    context 'uniqueness' do
      it { is_expected.to validate_uniqueness_of(:email).scoped_to(:ticket_id) }
    end
  end
end
