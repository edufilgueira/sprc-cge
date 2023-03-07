require 'rails_helper'

describe Integration::Supports::ManagementUnit do
  subject(:management_unit) { build(:integration_supports_management_unit) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_management_unit, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:cgf).of_type(:string) }
      it { is_expected.to have_db_column(:cnpj).of_type(:string) }
      it { is_expected.to have_db_column(:codigo).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_credor).of_type(:string) }
      it { is_expected.to have_db_column(:poder).of_type(:string) }
      it { is_expected.to have_db_column(:sigla).of_type(:string) }
      it { is_expected.to have_db_column(:tipo_administracao).of_type(:string) }
      it { is_expected.to have_db_column(:tipo_de_ug).of_type(:string) }
      it { is_expected.to have_db_column(:titulo).of_type(:string) }
    end

    describe 'indexes' do
      # Os testes de db:indexes ficam concentrados na aplicação sprc-data
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:cnpj) }
    it { is_expected.to validate_presence_of(:codigo) }
    it { is_expected.to validate_presence_of(:poder) }
    it { is_expected.to validate_presence_of(:sigla) }
    it { is_expected.to validate_presence_of(:tipo_administracao) }
    it { is_expected.to validate_presence_of(:tipo_de_ug) }
    it { is_expected.to validate_presence_of(:titulo) }
  end

  describe 'helpers' do
    it 'title' do
      expect(management_unit.title).to eq(management_unit.titulo)
    end
  end
end
