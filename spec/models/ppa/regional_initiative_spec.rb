require 'rails_helper'

RSpec.describe PPA::RegionalInitiative, type: :model do
  subject { build :ppa_regional_initiative }

  describe 'factories' do
    context 'default' do
      it { is_expected.to be_valid }
    end

    context 'invalid' do
      subject { build :ppa_regional_initiative, :invalid }

      it { is_expected.to be_invalid }
    end
  end

  context 'behaviors' do
    it_behaves_like PPA::Regional
    it_behaves_like PPA::Measurable
  end

  describe 'associations' do
    it { is_expected.to belong_to :initiative }

    it { is_expected.to have_many(:budgets).dependent(:destroy) }
  end

end
