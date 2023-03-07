require 'rails_helper'

RSpec.describe PPA::Proposal, type: :model do

  subject { build :ppa_proposal }

  describe 'factories' do
    context 'default' do
      it { is_expected.to be_valid }
    end

    context 'invalid' do
      subject { build :ppa_proposal, :invalid }

      it { is_expected.to be_invalid }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:plan) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:objective) }
    it { is_expected.to belong_to(:theme) }
    it { is_expected.to belong_to(:region) }

    it { is_expected.to have_many(:votes).dependent(:destroy).counter_cache(true) }
    it { is_expected.to have_many(:comments).dependent(:destroy).counter_cache(true) }
  end


  describe 'validations' do
    it { is_expected.to validate_presence_of(:justification) }
    it { is_expected.to validate_presence_of(:region) }
    it { is_expected.to validate_presence_of(:plan) }
    it { is_expected.to validate_presence_of(:theme) }
    it { is_expected.to validate_presence_of(:user) }
  end

end
