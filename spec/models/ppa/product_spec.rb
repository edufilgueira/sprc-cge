require 'rails_helper'

RSpec.describe PPA::Product, type: :model do

  subject { build :ppa_product }

  describe 'factories' do
    context 'default' do
      it { is_expected.to be_valid }
    end

    context 'invalid' do
      subject { build :ppa_product, :invalid }

      it { is_expected.to be_invalid }
    end
  end

  context 'behaviors' do
    it_behaves_like PPA::Regionalizable
    it_behaves_like PPA::AnnuallyRegionalizable
    it_behaves_like PPA::BienniallyRegionalizable
  end

  describe 'associations' do
    it { is_expected.to belong_to(:initiative) }

    # annual associations
    it { is_expected.to have_many(:annual_regional_products).dependent(:destroy) }
    it { is_expected.to have_many(:annual_regional_goals) }

    # biennial associations
    it { is_expected.to have_many(:biennial_regional_products).dependent(:destroy) }
    it { is_expected.to have_many(:biennial_regional_goals) }

    # quadrennial associations
    it { is_expected.to have_many(:regional_products).dependent(:destroy) }
    it { is_expected.to have_many(:regional_goals) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_uniqueness_of(:code).case_insensitive }
  end

end
