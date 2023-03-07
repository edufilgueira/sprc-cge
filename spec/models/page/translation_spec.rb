require 'rails_helper'

describe Page::Translation do
  let(:page) { create(:page) }
  subject(:page_translation) { create(:page_translation, page_id: page.id) }

  describe 'factories' do
    it { is_expected.to be_valid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:title).of_type(:string) }
      it { is_expected.to have_db_column(:content).of_type(:text) }
      it { is_expected.to have_db_column(:menu_title).of_type(:string) }
      it { is_expected.to have_db_column(:cached_charts).of_type(:text) }
    end
  end
end
