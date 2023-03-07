require 'rails_helper'

describe City do

  subject(:city) { build(:city) }

  describe 'factories' do
    it { is_expected.to be_valid }
  end

  describe 'db' do
    context 'columns' do
      it { is_expected.to have_db_column(:code).of_type(:integer).with_options(null: false) }
      it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:state) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:state) }

    it { is_expected.to validate_uniqueness_of(:code) }
  end

  describe 'scope' do
    it 'sorted' do
      expect(City.sorted).to eq(City.order(:name))
    end
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:acronym).to(:state).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:name).to(:region).with_arguments(allow_nil: true).with_prefix }

  end

  describe 'helpers' do
    it 'title' do
      expect(city.title).to eq("#{city.name}/#{city.state_acronym}")
    end
  end
end
