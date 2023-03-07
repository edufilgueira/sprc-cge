require 'rails_helper'

describe Integration::Servers::ServerSalary do

  subject(:server_salary) { build(:integration_servers_server_salary) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_servers_server, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:integration_servers_registration_id).of_type(:integer) }
      it { is_expected.to have_db_column(:integration_supports_server_role_id).of_type(:integer) }
      it { is_expected.to have_db_column(:server_name).of_type(:string) }
      it { is_expected.to have_db_column(:date).of_type(:date) }
      it { is_expected.to have_db_column(:status).of_type(:integer) }

      it { is_expected.to have_db_column(:income_total).of_type(:decimal).with_options(precision: 10, scale: 2) }
      it { is_expected.to have_db_column(:income_final).of_type(:decimal).with_options(precision: 10, scale: 2) }
      it { is_expected.to have_db_column(:income_dailies).of_type(:decimal).with_options(precision: 10, scale: 2) }

      it { is_expected.to have_db_column(:discount_total).of_type(:decimal).with_options(precision: 10, scale: 2) }
      it { is_expected.to have_db_column(:discount_under_roof).of_type(:decimal).with_options(precision: 10, scale: 2) }
      it { is_expected.to have_db_column(:discount_others).of_type(:decimal).with_options(precision: 10, scale: 2) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:date) }
      it { is_expected.to have_db_index(:integration_servers_registration_id) }
      it { is_expected.to have_db_index(:integration_supports_server_role_id) }
      it { is_expected.to have_db_index(:server_name) }
      it { is_expected.to have_db_index(:status) }
    end
  end

  describe 'associations' do
    it 'registration' do
      expect(subject).to belong_to(:registration).
        with_foreign_key('integration_servers_registration_id').
        class_name('Integration::Servers::Registration')
    end

    it 'server' do
      expect(subject).to have_one(:server).through(:registration)
    end

    it 'role' do
      expect(subject).to belong_to(:role).
        with_foreign_key('integration_supports_server_role_id').
        class_name('Integration::Supports::ServerRole')
    end

    it 'organ' do
      expect(subject).to have_one(:organ).through(:registration)
    end
  end

  describe 'validations' do
    context 'presence' do
      it { is_expected.to validate_presence_of(:registration) }
      it { is_expected.to validate_presence_of(:date) }
    end

    context 'uniqueness' do
      it { is_expected.to validate_uniqueness_of(:integration_servers_registration_id).scoped_to(:date) }
    end
  end

  describe 'enums' do
    it 'status' do
      statuses = [
        :civil_active,
        :militar_active,
        :civil_away_with_onus,
        :militar_away_with_onus,
        :civil_away_without_onus,
        :militar_away_without_onus,
        :pensioner,
        :food_pension,
        :injunction
      ]

      is_expected.to define_enum_for(:status).with_values(statuses)
    end
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:sigla).to(:organ).with_prefix }
    it { is_expected.to delegate_method(:title).to(:organ).with_prefix }
    it { is_expected.to delegate_method(:name).to(:role).with_prefix }
  end

  describe 'scopes' do
    it 'from_server' do
      first = create(:integration_servers_server_salary)
      second = create(:integration_servers_server_salary)

      result = Integration::Servers::ServerSalary.from_server(first.server)

      expect(result).to eq([first])
    end
  end

  describe 'helpers' do
    it 'title' do
      expect(server_salary.title).to eq(server_salary.server_name)
    end

    it 'functional_status_str' do
      registration = create(:integration_servers_registration, functional_status: :functional_status_retired)
      server_salary = create(:integration_servers_server_salary, registration: registration)

      expected = I18n.t('integration/servers/registration.functional_statuses.functional_status_retired')

      expect(server_salary.functional_status_str).to eq(expected)
    end
  end
end
