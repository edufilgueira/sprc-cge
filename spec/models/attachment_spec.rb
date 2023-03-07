require 'rails_helper'

describe Attachment do

  subject(:attachment) { build(:attachment) }

  describe 'factories' do
    it { is_expected.to be_valid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:attachmentable_id).of_type(:integer) }
      it { is_expected.to have_db_column(:attachmentable_type).of_type(:string) }
      it { is_expected.to have_db_column(:document_id).of_type(:string) }
      it { is_expected.to have_db_column(:document_filename).of_type(:string) }
      it { is_expected.to have_db_column(:imported_at).of_type(:date) }
      it { is_expected.to have_db_column(:title).of_type(:string) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index([:attachmentable_type, :attachmentable_id]) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:attachmentable) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:document) }

    describe 'title' do
      it { is_expected.to_not validate_presence_of(:title) }

      describe 'when attachmentable Page' do
        let(:attachment) { build(:attachment, attachmentable: create(:page)) }

        it { expect(attachment).to validate_presence_of(:title) }
      end
    end

    describe 'imported_at' do
      it { is_expected.to_not validate_presence_of(:imported_at) }

      describe 'when attachmentable Page' do
        let(:attachment) { build(:attachment, attachmentable: create(:page)) }

        it { expect(attachment).to validate_presence_of(:imported_at) }
      end
    end
  end

  describe 'methods' do
    describe '#attachment_url' do
      it { expect(attachment.url).to eq Refile.attachment_url(attachment, :document) }
    end
  end

  describe 'callbacks' do
    context 'before_save' do
      it 'parameretize document_filename' do
        attachment.document_filename = 'attachment[1].jpg'

        attachment.save

        expect(attachment.document_filename).to eq('attachment-1.jpg')
      end
    end
  end
end
