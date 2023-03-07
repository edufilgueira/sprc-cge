require 'rails_helper'

describe Page::SeriesItem do
  subject(:series_item) { build(:page_series_item) }

  describe 'factories' do
    it { is_expected.to be_valid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:value).of_type(:decimal) }
      it { is_expected.to have_db_column(:page_series_datum_id).of_type(:integer) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:page_series_datum_id) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:page_series_datum) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_presence_of(:page_series_datum) }
  end
end
