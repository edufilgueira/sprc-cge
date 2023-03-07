require 'rails_helper'

RSpec.describe PPA::Biennial::RegionalStrategy, type: :model do

  subject { build :ppa_biennial_regional_strategy }

  describe 'factories' do
    context 'default' do
      it { is_expected.to be_valid }
    end

    context 'priority' do
      subject { build(:ppa_biennial_regional_strategy, :priority) }

      it { is_expected.to be_valid.and be_prioritized }
    end

    context 'invalid' do
      subject { build :ppa_biennial_regional_strategy, :invalid }

      it { is_expected.to be_invalid }
    end
  end

  context 'behaviors' do
    it_behaves_like PPA::Biennial::Regionalized
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:name).to(:strategy).with_prefix }
    it { is_expected.to delegate_method(:name).to(:objective).with_prefix }
  end

  describe 'associations' do
    it { is_expected.to belong_to :strategy }
    it { is_expected.to have_one :objective }

    it { is_expected.to have_many :initiatives }
    it { is_expected.to have_many :products }

    # interactions
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:dislikes).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end

end
