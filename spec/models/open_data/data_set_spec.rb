require 'rails_helper'

describe OpenData::DataSet do
  subject(:data_set) { build(:data_set) }

  it_behaves_like 'models/base'
  it_behaves_like 'models/timestamp'

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:title).of_type(:string) }
      it { is_expected.to have_db_column(:description).of_type(:text) }
      it { is_expected.to have_db_column(:source_catalog).of_type(:string) }
      it { is_expected.to have_db_column(:organ_id).of_type(:integer) }
      it { is_expected.to have_db_column(:author).of_type(:string) }
    end

    describe 'indexes' do
      # Os testes de db:indexes ficam concentrados na aplicação sprc-data
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:organ).class_name('Integration::Supports::Organ') }

    it { is_expected.to have_many(:data_items).with_foreign_key(:open_data_data_set_id).inverse_of(:data_set).dependent(:destroy) }
    it { is_expected.to have_many(:data_set_vcge_categories).inverse_of(:data_set).with_foreign_key(:open_data_data_set_id).dependent(:destroy) }
    it { is_expected.to have_many(:vcge_categories).through(:data_set_vcge_categories) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:organ_id) }
  end

  describe 'nested' do
    it { is_expected.to accept_nested_attributes_for(:data_items).allow_destroy(true) }
    it { is_expected.to accept_nested_attributes_for(:data_set_vcge_categories).allow_destroy(true) }
  end

  describe 'scope' do
    it 'sorted' do
      first_unsorted = create(:data_set, title: 'Z')
      last_unsorted = create(:data_set, title: 'A')
      expect(OpenData::DataSet.sorted).to eq([last_unsorted, first_unsorted])
    end
  end
end
