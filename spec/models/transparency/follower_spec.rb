require 'rails_helper'

describe Transparency::Follower do
  subject(:follower) { build(:transparency_follower) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:transparency_follower, :invalid)).to be_invalid }
  end

  describe 'db' do
    # @SPRC-DATA tested
  end

  describe 'associations' do
    it { is_expected.to belong_to(:resourceable) }
  end

  describe 'validations' do
    describe 'presence' do
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_presence_of(:resourceable) }
      it { is_expected.to validate_presence_of(:transparency_link) }
    end

    describe 'uniqueness' do
      it { is_expected.to validate_uniqueness_of(:email).scoped_to([:resourceable_id, :resourceable_type, :unsubscribed_at]) }
    end

    describe 'format' do
      describe 'email' do
        context 'allowed' do
          it { is_expected.to allow_value('admin@example.com.br').for(:email) }
        end

        context 'denied' do
          it { is_expected.to_not allow_value('admin@example').for(:email) }
          it { is_expected.to_not allow_value('').for(:email) }
        end
      end
    end
  end
end
