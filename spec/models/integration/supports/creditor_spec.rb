require 'rails_helper'

describe Integration::Supports::Creditor do

  subject(:creditor) { build(:integration_supports_creditor) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_creditor, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:bairro).of_type(:string) }
      it { is_expected.to have_db_column(:cep).of_type(:string) }
      it { is_expected.to have_db_column(:codigo).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_contribuinte).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_distrito).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_municipio).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_nit).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_pis_pasep).of_type(:string) }
      it { is_expected.to have_db_column(:complemento).of_type(:string) }
      it { is_expected.to have_db_column(:cpf_cnpj).of_type(:string) }
      it { is_expected.to have_db_column(:data_atual).of_type(:string) }
      it { is_expected.to have_db_column(:data_cadastro).of_type(:string) }
      it { is_expected.to have_db_column(:email).of_type(:string) }
      it { is_expected.to have_db_column(:logradouro).of_type(:string) }
      it { is_expected.to have_db_column(:nome).of_type(:string) }
      it { is_expected.to have_db_column(:nome_municipio).of_type(:string) }
      it { is_expected.to have_db_column(:numero).of_type(:string) }
      it { is_expected.to have_db_column(:status).of_type(:string) }
      it { is_expected.to have_db_column(:telefone_contato).of_type(:string) }
      it { is_expected.to have_db_column(:uf).of_type(:string) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:codigo) }
      it { is_expected.to have_db_index(:cpf_cnpj) }
    end
  end

  describe 'validations' do
    describe 'presence' do
      it { is_expected.to validate_presence_of(:nome) }
      it { is_expected.to validate_presence_of(:codigo) }
      it { is_expected.to validate_presence_of(:cpf_cnpj) }
    end
  end

  describe 'scope' do
    it 'sorted' do
      first_unsorted = create(:integration_supports_creditor, nome: 'MARIA TEREZA B DE MENEZES FONTENELE')
      last_unsorted = create(:integration_supports_creditor, nome: 'PREFEITURA MUNICIPAL DE ANTONINA DO NORTE')
      expect(Integration::Supports::Creditor.sorted).to eq([first_unsorted, last_unsorted])
    end
  end

  describe 'helpers' do
    it 'title' do
      expect(creditor.title).to eq(creditor.nome)
    end
  end
end
