require 'rails_helper'

RSpec.describe PPA::ProposalTheme, type: :model do

  subject { build :ppa_proposal_theme }
  

  describe 'factories' do
    context 'valid' do
      it { is_expected.to be_valid }
    end

    context 'invalid' do
      subject { build :ppa_proposal_theme, :invalid }

      it { is_expected.to be_invalid }
    end
   end

  describe 'associations' do
    it { is_expected.to belong_to(:plan) }
    it { is_expected.to belong_to(:region) }       
  end

  describe 'delegate' do   
    it { is_expected.to delegate_method(:name).to(:region).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:name).to(:plan).with_arguments(allow_nil: true).with_prefix }
  end 

  describe 'validations' do
    it { is_expected.to validate_presence_of(:start_in ) }
    it { is_expected.to validate_presence_of(:end_in ) }
    it { is_expected.to validate_presence_of(:region) }
    it { is_expected.to validate_presence_of(:plan) }
  end
end