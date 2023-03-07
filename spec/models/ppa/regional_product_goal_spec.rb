require 'rails_helper'

RSpec.describe PPA::RegionalProductGoal, type: :model do

  subject(:goal) { build :ppa_regional_product_goal }

  describe 'factories' do
    context 'default' do
      it { is_expected.to be_valid }
    end

    context 'invalid' do
      subject { build :ppa_regional_product_goal, :invalid }

      it { is_expected.to be_invalid }
    end
  end

  context 'behaviors' do
    it_behaves_like PPA::Measurement
  end

  context 'associations' do
    it { is_expected.to belong_to :regional_product }
  end

end
