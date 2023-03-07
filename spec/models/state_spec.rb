require 'rails_helper'

describe State do

  subject(:state) { build(:state) }

  describe 'factories' do
    it { is_expected.to be_valid }
  end

  describe 'db' do
    context 'columns' do
      it { is_expected.to have_db_column(:code).of_type(:integer).with_options(null: false) }
      it { is_expected.to have_db_column(:acronym).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:cities).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:acronym) }
    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to validate_uniqueness_of(:code) }
    it { is_expected.to validate_uniqueness_of(:acronym) }
  end

  describe 'scope' do
    it 'sorted' do
      expect(State.sorted).to eq(State.order(:name))
    end

    context 'default' do
      let(:state) { create(:state, acronym: 'CE') }

      before { state }

      it { expect(State.default).to eq(state) }
    end
  end

  describe 'helpers' do
    it 'title' do
      expect(state.title).to eq(state.name)
    end
  end

end
