require 'rails_helper'

RSpec.describe PPA::Objective, type: :model do

  subject { build :ppa_objective }

  describe 'factories' do
    context 'default' do
      it { is_expected.to be_valid }
    end

    context 'invalid' do
      subject { build :ppa_objective, :invalid }

      it { is_expected.to be_invalid }
    end
  end

  context 'behaviors' do
    it_behaves_like PPA::BienniallyRegionalizable
  end

  describe 'associations' do
    it { is_expected.to belong_to(:region) }
    it { is_expected.to have_many(:strategies).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:region_id) }
    it { is_expected.to validate_uniqueness_of(:code) }
  end

  describe '#default_scope' do
    context 'hiding theme with disabled_at' do
      context 'when default_scope' do
        it 'count zero' do
          create(:ppa_objective, disabled_at: DateTime.now)
          expect(PPA::Objective.count).to eq(0)
        end
      end

      context 'when unscoped' do
        it 'count one' do
          create(:ppa_objective, disabled_at: DateTime.now)
          expect(PPA::Objective.unscoped.count).to eq(1)
        end
      end
    end
  end
end
