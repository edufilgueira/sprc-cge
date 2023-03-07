require 'rails_helper'

describe Integration::Servers::Server do
  subject(:integration_servers_server) { build(:integration_servers_server) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_servers_server, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:dsc_cpf).of_type(:string) }
      it { is_expected.to have_db_column(:dsc_funcionario).of_type(:string) }
      it { is_expected.to have_db_column(:dth_nascimento).of_type(:date) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:dsc_funcionario) }
      it { is_expected.to have_db_index(:dsc_cpf) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:dsc_funcionario) }
    it { is_expected.to validate_presence_of(:dsc_cpf) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:registrations).dependent(:destroy) }
    it { is_expected.to have_many(:proceeds).through(:registrations) }
    it { is_expected.to have_many(:server_salaries).through(:registrations) }
  end
end
