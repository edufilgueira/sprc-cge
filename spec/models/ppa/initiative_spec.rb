require 'rails_helper'

RSpec.describe PPA::Initiative, type: :model do
  subject(:initiative) { build :ppa_initiative }

  describe 'factories' do
    context 'default' do
      it { is_expected.to be_valid }
    end

    context 'invalid' do
      subject { build :ppa_initiative, :invalid }

      it { is_expected.to be_invalid }
    end
  end

  context 'behaviors' do
    it_behaves_like PPA::Regionalizable
    it_behaves_like PPA::AnnuallyRegionalizable
    it_behaves_like PPA::BienniallyRegionalizable
  end

  describe 'associations' do
    it { is_expected.to have_many(:initiative_strategies).dependent(:destroy) }
    it { is_expected.to have_many(:strategies) }
    it { is_expected.to have_many(:products).dependent(:destroy) }

    # annual associations
    it { is_expected.to have_many(:annual_regional_initiatives).dependent(:destroy) }
    it { is_expected.to have_many(:annual_regional_budgets) }
    it { is_expected.to have_many(:annual_regional_products) }

    # biennial associations
    it { is_expected.to have_many(:biennial_regional_initiatives).dependent(:destroy) }
    it { is_expected.to have_many(:biennial_regional_budgets) }
    it { is_expected.to have_many(:biennial_regional_products) }

    # quadrennial associations
    it { is_expected.to have_many(:regional_initiatives).dependent(:destroy) }
    it { is_expected.to have_many(:regional_budgets) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_uniqueness_of(:code).case_insensitive }
  end

end
