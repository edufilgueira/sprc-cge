require 'rails_helper'

RSpec.describe PPA::Biennial::RegionalInitiative, type: :model do

  subject { build :ppa_biennial_regional_initiative }

  describe 'factories' do
    context 'default' do
      it { is_expected.to be_valid }
    end

    context 'invalid' do
      subject { build :ppa_biennial_regional_initiative, :invalid }

      it { is_expected.to be_invalid }
    end
  end

  context 'behaviors' do
    it_behaves_like PPA::Biennial::Regionalized
    it_behaves_like PPA::Biennial::Measurable
  end

  describe 'associations' do
    it { is_expected.to belong_to :initiative }

    it { is_expected.to have_many(:budgets).dependent(:destroy) }
    it { is_expected.to have_many :products }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:name).to(:initiative).with_prefix(:original) }
    it { is_expected.to delegate_method(:code).to(:initiative) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
  end

end
