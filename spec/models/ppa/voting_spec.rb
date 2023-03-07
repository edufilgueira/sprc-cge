require 'rails_helper'

RSpec.describe PPA::Voting, type: :model do

  subject { build :ppa_voting }

  describe 'factories' do
    context 'default' do
      it { is_expected.to be_valid }
    end

    context 'invalid' do
      subject { build :ppa_voting, :invalid }

      it { is_expected.to be_invalid }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:plan) }
    it { is_expected.to belong_to(:region) }

  end


  describe 'validations' do
    it { is_expected.to validate_presence_of(:plan) }
    it { is_expected.to validate_presence_of(:region) }
    it { is_expected.to validate_presence_of(:start_in) }
    it { is_expected.to validate_presence_of(:end_in) }
  end

end