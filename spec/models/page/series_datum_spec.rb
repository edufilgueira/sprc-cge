require 'rails_helper'

describe Page::SeriesDatum do
  subject(:series_datum) { build(:page_series_datum) }

  describe 'factories' do
    it { is_expected.to be_valid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:series_type).of_type(:integer) }
      it { is_expected.to have_db_column(:page_chart_id).of_type(:integer) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:page_chart_id) }
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:page_series_items) }

    it { is_expected.to belong_to(:page_chart) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:series_type) }
    it { is_expected.to validate_presence_of(:page_chart) }
  end

  describe 'nested' do
    it { is_expected.to accept_nested_attributes_for(:page_series_items) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:series_type).with_values([:column, :line, :area]) }
  end
end
