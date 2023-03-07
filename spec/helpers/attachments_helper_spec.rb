require 'rails_helper'

describe AttachmentsHelper do
  include Refile::AttachmentHelper

  let(:attachment) { create(:attachment) }

  it 'document_url' do
    expected = Refile.attachment_url(attachment, :document)

    expect(document_url(attachment)).to eq(expected)
  end

  describe 'document_image_tag' do
    context 'when document is an image' do
      it 'smaller' do
        expected = image_tag(attachment_url(attachment, :document, :fill, 30, 30))

        expect(document_image_tag(attachment, :smaller)).to eq(expected)
      end
      it 'small' do
        expected = image_tag(attachment_url(attachment, :document, :fill, 48, 48))

        expect(document_image_tag(attachment, :small)).to eq(expected)
      end

      it 'normal' do
        expected = image_tag(attachment_url(attachment, :document, :fill, 90, 90))

        expect(document_image_tag(attachment, :normal)).to eq(expected)
      end
    end

    context 'when document is not an image' do

      before do
        document = Refile::FileDouble.new("test", "logo.csv", content_type: "text/csv")
        attachment.update(document: document)
      end

      it 'small' do
        expected = image_tag("document.png", width: 48, height: 48)

        expect(document_image_tag(attachment, :small)).to eq(expected)
      end

      it 'normal' do
        expected = image_tag("document.png", width: 90, height: 90)

        expect(document_image_tag(attachment, :normal)).to eq(expected)
      end

    end
  end

end
