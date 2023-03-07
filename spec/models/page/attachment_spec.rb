require 'rails_helper'
require 'page/attachment'

describe Page::Attachment do
  subject(:page_attachment) { build(:page_attachment) }

  it_behaves_like 'models/timestamp'

  describe 'factories' do
    it { is_expected.to be_valid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:page_id).of_type(:integer) }
      it { is_expected.to have_db_column(:document_id).of_type(:string) }
      it { is_expected.to have_db_column(:document_filename).of_type(:string) }
      it { is_expected.to have_db_column(:imported_at).of_type(:date) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:page_id) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:page) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:document) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:imported_at) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:year).to(:imported_at).with_prefix }
  end

  describe 'helpers' do
    describe 'url' do
      it { expect(page_attachment.url).to eq(Refile.attachment_url(page_attachment, :document)) }
    end
  end

  describe 'scope' do
    it '#sorted' do
      expected = Page::Attachment.order('imported_at desc, created_at desc').to_sql
      result = Page::Attachment.sorted.to_sql

      expect(result).to eq(expected)
    end

    it '#by_year' do
      year = Date.current.year
      expected = Page::Attachment.where('extract(year from imported_at) = ?', year).to_sql
      result = Page::Attachment.by_year(year).to_sql

      expect(result).to eq(expected)
		end

    it '#by_title' do
			title = 'Arquivo'
      expected = Page::Attachment.where("title ILIKE '%#{title}%'").to_sql
			result = Page::Attachment.by_title(title).to_sql

      expect(result).to eq(expected)
		end

		it '#join_attachment_detail' do
			expected = Page::Attachment.joins('JOIN page_attachment_translations ON page_attachment_translations.page_attachment_id = page_attachments.id').to_sql
			result = Page::Attachment.join_attachment_detail.to_sql

			expect(result).to eq(expected)
		end
  end
end
