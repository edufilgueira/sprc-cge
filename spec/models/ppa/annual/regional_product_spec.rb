require 'rails_helper'

RSpec.describe PPA::Annual::RegionalProduct, type: :model do

  subject { build :ppa_annual_regional_product }

  describe 'factories' do
    context 'default' do
      it { is_expected.to be_valid }
    end

    context 'invalid' do
      subject { build :ppa_annual_regional_product, :invalid }

      it { is_expected.to be_invalid }
    end
  end

  context 'behaviors' do
    it_behaves_like PPA::Annual::Regionalized
    it_behaves_like PPA::Annual::Measurable
  end

  describe 'associations' do
    it { is_expected.to have_many(:goals).dependent(:destroy) }
  end

end
