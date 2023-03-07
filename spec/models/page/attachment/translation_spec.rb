require 'rails_helper'
require 'page/attachment'

describe Page::Attachment::Translation do
  let(:page_attachment) { create(:page_attachment) }
  subject(:page_attachment_translation) { build(:page_attachment_translation, page_attachment_id: page_attachment.id) }

  describe 'factories' do
    it { is_expected.to be_valid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:title).of_type(:string) }
    end
  end
end
