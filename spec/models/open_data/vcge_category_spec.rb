require 'rails_helper'

describe OpenData::VcgeCategory do
  subject(:vcge_category) { build(:vcge_category) }

  it_behaves_like 'models/base'

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:title).of_type(:string) }
      it { is_expected.to have_db_column(:href).of_type(:string) }
      it { is_expected.to have_db_column(:name).of_type(:string) }
      it { is_expected.to have_db_column(:vcge_id).of_type(:string) }
    end

    describe 'indexes' do
      # Os testes de db:indexes ficam concentrados na aplicação sprc-data
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:child_associations).with_foreign_key(:parent_id).class_name('OpenData::VcgeCategoryAssociation').dependent(:destroy) }
    it { is_expected.to have_many(:children).through(:child_associations) }

    it { is_expected.to have_many(:parent_associations).with_foreign_key(:child_id).class_name('OpenData::VcgeCategoryAssociation').dependent(:destroy) }
    it { is_expected.to have_many(:parents).through(:parent_associations) }

    it { is_expected.to have_many(:data_set_vcge_categories).with_foreign_key(:data_set_vcge_category_id).class_name('OpenData::DataSetVcgeCategory').dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:href) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:vcge_id) }

    it { is_expected.to validate_uniqueness_of(:vcge_id) }
  end
end
