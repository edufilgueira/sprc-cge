require 'rails_helper'

describe Page::SeriesItem::Translation do
  let(:page_series_item) { create(:page_series_item) }
  subject(:page_series_item_translation) { build(:page_series_item_translation, page_series_item_id: page_series_item.id) }

  describe 'factories' do
    it { is_expected.to be_valid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:title).of_type(:string) }
    end
  end
end
