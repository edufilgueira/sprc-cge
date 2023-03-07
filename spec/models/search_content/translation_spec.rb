require 'rails_helper'

describe SearchContent::Translation do
  let(:search_content) { create(:search_content) }
  subject(:search_content_translation) { build(:search_content_translation, search_content_id: search_content.id) }

  describe 'factories' do
    it { is_expected.to be_valid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:title).of_type(:string) }
      it { is_expected.to have_db_column(:description).of_type(:text) }
      it { is_expected.to have_db_column(:content).of_type(:text) }
    end
  end
end
