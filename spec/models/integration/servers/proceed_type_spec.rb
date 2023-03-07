require 'rails_helper'

describe Integration::Servers::ProceedType  do

  subject(:integration_servers_proceed_type) { build(:integration_servers_proceed_type) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_servers_proceed_type, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:cod_provento).of_type(:string) }
      it { is_expected.to have_db_column(:dsc_provento).of_type(:string) }
      it { is_expected.to have_db_column(:dsc_tipo).of_type(:string) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      # Os testes de db:indexes ficam concentrados na aplicação sprc-data
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:cod_provento) }
    it { is_expected.to validate_presence_of(:dsc_provento) }
    it { is_expected.to validate_presence_of(:dsc_tipo) }
  end

  describe 'scope' do
    it 'sorted' do
      expect(Integration::Servers::ProceedType.sorted).to eq(Integration::Servers::ProceedType.order(:cod_provento))
    end
  end

  describe 'helpers' do
    it 'title' do
      expect(integration_servers_proceed_type.title).to eq(integration_servers_proceed_type.dsc_provento)
    end
  end
end
