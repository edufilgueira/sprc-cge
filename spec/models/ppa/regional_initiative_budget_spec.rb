require 'rails_helper'

RSpec.describe PPA::RegionalInitiativeBudget, type: :model do

  subject(:budget) { build :ppa_regional_initiative_budget }

  describe 'factories' do
    context 'default' do
      it { is_expected.to be_valid }
    end

    context 'invalid' do
      subject { build :ppa_regional_initiative_budget, :invalid }

      it { is_expected.to be_invalid }
    end
  end

  context 'behaviors' do
    it_behaves_like PPA::Measurement
  end

  context 'associations' do
    it { is_expected.to belong_to :regional_initiative }
  end

end
