require 'rails_helper'

describe Integration::Supports::ServerRole do

  subject(:integration_supports_server_role) { build(:integration_supports_server_role) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_servers_server, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:name).of_type(:string) }
    end

    describe 'indexes' do
      # Os testes de db:indexes ficam concentrados na aplicação sprc-data
    end
  end

  describe 'associations' do
    it 'server_salaries' do
      expect(subject).to have_many(:server_salaries).
        with_foreign_key('integration_supports_server_role_id').
        class_name('Integration::Servers::ServerSalary')
    end

    it 'organ_server_roles' do
      expect(subject).to have_many(:organ_server_roles).
        with_foreign_key('integration_supports_server_role_id').
        class_name('Integration::Supports::OrganServerRole')
    end

    it 'organs' do
      expect(subject).to have_many(:organs).through(:organ_server_roles).
        class_name('Integration::Supports::Organ')
    end
  end

  describe 'validations' do
    context 'presence' do
      it { is_expected.to validate_presence_of(:name) }
    end
  end

  describe 'scope' do
    it 'sorted' do
      expect(Integration::Supports::ServerRole.sorted).to eq(Integration::Supports::ServerRole.order(:name))
    end
  end

  describe 'validations' do
    context 'presence' do
      it { is_expected.to validate_presence_of(:name) }
    end
  end
end
