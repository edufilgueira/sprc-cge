require 'rails_helper'

describe MobileApp do

  subject(:mobile_app) { build(:mobile_app) }

  describe 'factories' do
    it { is_expected.to be_valid }
    it { expect(build(:mobile_app, :invalid)).not_to be_valid }
  end

  describe 'db' do
    context 'columns' do
      it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:description).of_type(:text) }
      it { is_expected.to have_db_column(:link_apple_store).of_type(:string) }
      it { is_expected.to have_db_column(:link_google_play).of_type(:string) }
      it { is_expected.to have_db_column(:official).of_type(:boolean) }

      it { is_expected.to have_db_column(:icon_id).of_type(:string) }
      it { is_expected.to have_db_column(:icon_filename).of_type(:string) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:icon) }
    it { is_expected.to validate_presence_of(:mobile_tags) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe 'associations' do
    it { is_expected.to have_and_belong_to_many(:mobile_tags) }
  end

  describe 'scope' do
    it 'sorted' do
      expected = MobileApp.order('mobile_apps.name ASC').to_sql.downcase
      result = MobileApp.sorted.to_sql.downcase
      expect(result).to eq(expected)
    end

    it 'official' do
      mobile_app_1 = create(:mobile_app, official: true)
      mobile_app_2 = create(:mobile_app, official: false)

      expect(MobileApp.official).to eq [mobile_app_1]
    end

    it 'unofficial' do
      mobile_app_1 = create(:mobile_app, official: true)
      mobile_app_2 = create(:mobile_app, official: false)

      expect(MobileApp.unofficial).to eq [mobile_app_2]
    end
  end

  describe 'helpers' do
    it 'title' do
      expect(mobile_app.title).to eq(mobile_app.name)
    end
  end

  describe 'methods' do
    describe 'url' do
      it { expect(mobile_app.url).to eq Refile.attachment_url(mobile_app, :icon) }
    end
  end
end
