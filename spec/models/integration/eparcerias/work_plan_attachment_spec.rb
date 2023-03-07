require 'rails_helper'

describe Integration::Eparcerias::WorkPlanAttachment do

  subject(:work_plan_attachment) { build(:integration_eparcerias_work_plan_attachment) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_eparcerias_work_plan_attachment, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:isn_sic).of_type(:integer) }
      it { is_expected.to have_db_column(:file_name).of_type(:string) }
      it { is_expected.to have_db_column(:file_size).of_type(:integer) }
      it { is_expected.to have_db_column(:file_type).of_type(:string) }
      it { is_expected.to have_db_column(:description).of_type(:text) }
    end

    describe 'indexes' do
      # Os testes de db:indexes ficam concentrados na aplicação sprc-data
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:isn_sic) }
    it { is_expected.to validate_presence_of(:file_name) }
    it { is_expected.to validate_presence_of(:file_size) }
    it { is_expected.to validate_presence_of(:file_type) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:convenant).with_foreign_key(:isn_sic).with_primary_key(:isn_sic) }
  end
end
