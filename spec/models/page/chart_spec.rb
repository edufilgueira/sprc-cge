require 'rails_helper'

describe Page::Chart do
  subject(:chart) { build(:page_chart) }

  describe 'factories' do
    it { is_expected.to be_valid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:page_id).of_type(:integer) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:page_id) }
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:page_series_data) }

    it { is_expected.to belong_to(:page) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:page) }
  end

  describe 'nested' do
    it { is_expected.to accept_nested_attributes_for(:page_series_data) }
  end
end
