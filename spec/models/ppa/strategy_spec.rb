require 'rails_helper'

RSpec.describe PPA::Strategy, type: :model do

  subject { build :ppa_strategy }

  describe 'factories' do
    context 'default' do
      it { is_expected.to be_valid }
    end

    context 'invalid' do
      subject { build :ppa_strategy, :invalid }

      it { is_expected.to be_invalid }
    end
  end

  context 'behaviors' do
    it_behaves_like PPA::AnnuallyRegionalizable
    it_behaves_like PPA::BienniallyRegionalizable
  end

  describe 'associations' do
    it { is_expected.to belong_to(:objective) }

    it { is_expected.to have_many(:initiative_strategies).dependent(:destroy) }
    it { is_expected.to have_many(:initiatives) }
    it { is_expected.to have_many(:products) }

    # annual associations
    it { is_expected.to have_many(:annual_regional_strategies).dependent(:destroy) }
    it { is_expected.to have_many(:annual_regional_initiatives) }
    it { is_expected.to have_many(:annual_regional_products) }

    # biennial associations
    it { is_expected.to have_many(:biennial_regional_strategies).dependent(:destroy) }
    it { is_expected.to have_many(:biennial_regional_initiatives) }
    it { is_expected.to have_many(:biennial_regional_products) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_uniqueness_of(:code).case_insensitive }
    it { is_expected.to validate_presence_of(:name) }
  end

  describe '#default_scope' do
    context 'hiding strategy with disabled_at' do
      context 'when default_scope' do
        it 'count zero' do
          create(:ppa_strategy, disabled_at: DateTime.now)
          expect(PPA::Strategy.count).to eq(0)
        end
      end

      context 'when unscoped' do
        it 'count one' do
          create(:ppa_strategy, disabled_at: DateTime.now)
          expect(PPA::Strategy.unscoped.count).to eq(1)
        end
      end
    end
  end
end
