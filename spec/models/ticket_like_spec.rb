require 'rails_helper'

describe TicketLike do
  subject(:ticket_like) { build(:ticket_like) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:ticket_like, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:ticket_id).of_type(:integer) }
      it { is_expected.to have_db_column(:user_id).of_type(:integer) }
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:ticket_id) }
      it { is_expected.to have_db_index(:user_id) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:ticket) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:ticket) }
    it { is_expected.to validate_presence_of(:user) }
  end
end
