require 'rails_helper'

describe MobileTag do

  subject(:mobile_tag) { build(:mobile_tag) }

  describe 'factories' do
    it { is_expected.to be_valid }
    it { expect(build(:mobile_tag, :invalid)).not_to be_valid }
  end

  describe 'db' do
    context 'columns' do
      it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe 'scope' do
    it 'sorted' do
      expect(MobileTag.sorted).to eq(MobileTag.order(:name))
    end
  end

  describe 'helpers' do
    it 'title' do
      expect(mobile_tag.title).to eq(mobile_tag.name)
    end
  end
end
