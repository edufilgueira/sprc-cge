require 'rails_helper'

describe OpenData::DataSetVcgeCategory do
  subject(:data_set_vcge_category) { build(:data_set_vcge_category) }

  it_behaves_like 'models/base'

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:open_data_data_set_id).of_type(:integer) }
      it { is_expected.to have_db_column(:open_data_vcge_category_id).of_type(:integer) }
    end

    describe 'indexes' do
      # Os testes de db:indexes ficam concentrados na aplicação sprc-data
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:data_set).class_name('OpenData::DataSet') }
    it { is_expected.to belong_to(:vcge_category).class_name('OpenData::VcgeCategory') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:data_set) }
    it { is_expected.to validate_presence_of(:vcge_category) }
  end
end
