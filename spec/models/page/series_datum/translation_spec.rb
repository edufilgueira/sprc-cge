require 'rails_helper'

describe Page::SeriesDatum::Translation do
  let(:page_series_datum) { create(:page_series_datum) }
  subject(:page_series_datum_translation) { build(:page_series_datum_translation, page_series_datum_id: page_series_datum.id) }

  describe 'factories' do
    it { is_expected.to be_valid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:title).of_type(:string) }
    end
  end
end
