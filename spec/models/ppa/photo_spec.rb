require 'rails_helper'

RSpec.describe PPA::Photo, type: :model do

  subject(:photo) { build :ppa_photo }

  describe 'factories' do
    it { is_expected.to be_valid }

    context 'without attachment' do
      subject { build :ppa_photo, :invalid }

      it { is_expected.to be_invalid }
    end
  end

  describe 'validations' do
    context 'without attachment' do
      before { photo.attachment_filename = nil }

      it 'is invalid' do
        expect(photo.valid?).to be_falsey
      end
    end

    context 'with invalid extension' do
      let(:photo) { build :ppa_photo, attachment: StringIO.new('foo') }

      before { photo.validate }

      let(:error) { photo.errors.details[:attachment].first[:error] }

      it 'is invalid' do
        expect(error).to eq(:invalid_content_type)
      end
    end
  end

end
