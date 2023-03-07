require 'rails_helper'

RSpec.describe PPA::Theme, type: :model do

  subject { build :ppa_theme }

  describe 'factories' do
    context 'default' do
      it { is_expected.to be_valid }
    end

    context 'invalid' do
      subject { build :ppa_theme, :invalid }

      it { is_expected.to be_invalid }
    end
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:name).of_type(:string) }
      it { is_expected.to have_db_column(:axis_id).of_type(:integer) }
      it { is_expected.to have_db_column(:code).of_type(:string) }
      it { is_expected.to have_db_column(:description).of_type(:text) }
      it { is_expected.to have_db_column(:isn).of_type(:integer) }
    end
  end

  context 'behaviors' do
    it_behaves_like PPA::BienniallyRegionalizable
  end

  describe 'associations' do
    it { is_expected.to belong_to(:axis) }
    it { is_expected.to have_many(:theme_strategies) }
    it { is_expected.to have_many(:strategies).through(:theme_strategies) }
    it { is_expected.to have_many(:objectives).through(:strategies) }
    it { is_expected.to have_many(:region_themes).class_name('PPA::Revision::Review::RegionTheme') }

    it { is_expected.to have_many(:proposals) }
    it { is_expected.to have_many(:annual_regional_strategies).through(:strategies) }
    it { is_expected.to have_many(:biennial_regional_strategies).through(:strategies) }
  end


  describe 'validations' do
    it { is_expected.to validate_presence_of(:axis) }
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:code).scoped_to(:axis_id) }
  end

  describe '#default_scope' do
    context 'hiding theme with disabled_at' do
      context 'when default_scope' do
        it 'count zero' do
          create(:ppa_theme, disabled_at: DateTime.now)
          expect(PPA::Theme.count).to eq(0)
        end
      end

      context 'when unscoped' do
        it 'count one' do
          create(:ppa_theme, disabled_at: DateTime.now)
          expect(PPA::Theme.unscoped.count).to eq(1)
        end
      end
    end
  end
end
