require 'rails_helper'

RSpec.describe PPA::Annual::RegionalStrategy, type: :model do

  subject { build :ppa_annual_regional_strategy }

  describe 'factories' do
    context 'default' do
      it { is_expected.to be_valid }
    end

    context 'invalid' do
      subject { build :ppa_annual_regional_strategy, :invalid }

      it { is_expected.to be_invalid }
    end
  end

  context 'behaviors' do
    it_behaves_like PPA::Annual::Regionalized
  end

  describe 'associations' do
    it { is_expected.to belong_to :strategy }

    it { is_expected.to have_many(:initiatives) }
    it { is_expected.to have_many(:products) }
  end

end
