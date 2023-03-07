require 'rails_helper'

RSpec.describe PPA::Document, type: :model do

  subject(:document) { build :ppa_document }

  describe 'factories' do
    it { is_expected.to be_valid }

    context 'without attachment' do
      subject { build :ppa_document, :invalid }

      it { is_expected.to be_invalid }
    end
  end

  describe 'validations' do
    context 'without attachment' do
      before { document.attachment_filename = nil }

      it 'is invalid' do
        expect(document.valid?).to be_falsey
      end
    end

    context 'with invalid extension' do
      let(:document) { build :ppa_document, attachment: StringIO.new('foo') }

      before { document.validate }

      let(:error) { document.errors.details[:attachment].first[:error] }

      it 'is invalid' do
        expect(error).to eq(:invalid_extension)
      end
    end
  end

end
