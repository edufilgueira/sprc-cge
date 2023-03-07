require 'rails_helper'

RSpec.describe PPA::Biennial::RegionalProduct, type: :model do

  subject { build :ppa_biennial_regional_product }

  describe 'factories' do
    context 'default' do
      it { is_expected.to be_valid }
    end

    context 'invalid' do
      subject { build :ppa_biennial_regional_product, :invalid }

      it { is_expected.to be_invalid }
    end
  end

  context 'behaviors' do
    it_behaves_like PPA::Biennial::Regionalized
    it_behaves_like PPA::Biennial::Measurable
  end

  describe 'associations' do
    it { is_expected.to belong_to :product }

    it { is_expected.to have_many(:goals).dependent(:destroy) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:name).to(:product) }
  end
end
