require 'rails_helper'

describe CitizenComment do

  subject(:citizen_comment) { build(:citizen_comment) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:citizen_comment, :invalid)).to be_invalid }
  end

  describe 'db' do
    context 'columns' do
      it { is_expected.to have_db_column(:description).of_type(:text) }
      it { is_expected.to have_db_column(:ticket_id).of_type(:integer).with_options(null: false) }
      it { is_expected.to have_db_column(:user_id).of_type(:integer).with_options(null: false) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end
  end

  describe 'validations' do
    context 'presence' do
      it { is_expected.to validate_presence_of(:description) }
      it { is_expected.to validate_presence_of(:ticket) }
      it { is_expected.to validate_presence_of(:user) }
    end
  end

  describe 'scope' do
    it 'sorted' do
      expect(CitizenComment.sorted).to eq(CitizenComment.order(created_at: :desc))
    end
  end

  describe 'helpers' do
    context 'title' do
      it { expect(citizen_comment.title).to eq("") }
    end
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:title).to(:user).with_prefix }
  end
end
