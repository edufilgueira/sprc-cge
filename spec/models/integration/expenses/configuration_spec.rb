require 'rails_helper'

describe Integration::Expenses::Configuration do

  subject(:configuration) { build(:integration_expenses_configuration) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_expenses_configuration, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:npf_wsdl).of_type(:string) }
      it { is_expected.to have_db_column(:npf_headers_soap_action).of_type(:string) }
      it { is_expected.to have_db_column(:npf_operation).of_type(:string) }
      it { is_expected.to have_db_column(:npf_response_path).of_type(:string) }
      it { is_expected.to have_db_column(:npf_user).of_type(:string) }
      it { is_expected.to have_db_column(:npf_password).of_type(:string) }
      it { is_expected.to have_db_column(:ned_wsdl).of_type(:string) }
      it { is_expected.to have_db_column(:ned_headers_soap_action).of_type(:string) }
      it { is_expected.to have_db_column(:ned_operation).of_type(:string) }
      it { is_expected.to have_db_column(:ned_response_path).of_type(:string) }
      it { is_expected.to have_db_column(:ned_user).of_type(:string) }
      it { is_expected.to have_db_column(:ned_password).of_type(:string) }
      it { is_expected.to have_db_column(:nld_wsdl).of_type(:string) }
      it { is_expected.to have_db_column(:nld_headers_soap_action).of_type(:string) }
      it { is_expected.to have_db_column(:nld_operation).of_type(:string) }
      it { is_expected.to have_db_column(:nld_response_path).of_type(:string) }
      it { is_expected.to have_db_column(:nld_user).of_type(:string) }
      it { is_expected.to have_db_column(:nld_password).of_type(:string) }
      it { is_expected.to have_db_column(:npd_wsdl).of_type(:string) }
      it { is_expected.to have_db_column(:npd_headers_soap_action).of_type(:string) }
      it { is_expected.to have_db_column(:npd_operation).of_type(:string) }
      it { is_expected.to have_db_column(:npd_response_path).of_type(:string) }
      it { is_expected.to have_db_column(:npd_user).of_type(:string) }
      it { is_expected.to have_db_column(:npd_password).of_type(:string) }
      it { is_expected.to have_db_column(:budget_balance_wsdl).of_type(:string) }
      it { is_expected.to have_db_column(:budget_balance_headers_soap_action).of_type(:string) }
      it { is_expected.to have_db_column(:budget_balance_operation).of_type(:string) }
      it { is_expected.to have_db_column(:budget_balance_response_path).of_type(:string) }
      it { is_expected.to have_db_column(:budget_balance_user).of_type(:string) }
      it { is_expected.to have_db_column(:budget_balance_password).of_type(:string) }
      it { is_expected.to have_db_column(:last_importation).of_type(:datetime) }
      it { is_expected.to have_db_column(:log).of_type(:text) }
      it { is_expected.to have_db_column(:status).of_type(:integer) }
      it { is_expected.to have_db_column(:started_at).of_type(:date) }
      it { is_expected.to have_db_column(:finished_at).of_type(:date) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end
  end

  describe 'associations' do
    it { is_expected.to have_one(:schedule) }
  end

  describe 'nested' do
    it { is_expected.to accept_nested_attributes_for(:schedule) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:cron_syntax_frequency).to(:schedule) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:npf_wsdl) }
    it { is_expected.to validate_presence_of(:npf_operation) }
    it { is_expected.to validate_presence_of(:npf_response_path) }
    it { is_expected.to validate_presence_of(:npf_user) }
    it { is_expected.to validate_presence_of(:npf_password) }
    it { is_expected.to validate_presence_of(:ned_wsdl) }
    it { is_expected.to validate_presence_of(:ned_operation) }
    it { is_expected.to validate_presence_of(:ned_response_path) }
    it { is_expected.to validate_presence_of(:ned_user) }
    it { is_expected.to validate_presence_of(:ned_password) }
    it { is_expected.to validate_presence_of(:nld_wsdl) }
    it { is_expected.to validate_presence_of(:nld_operation) }
    it { is_expected.to validate_presence_of(:nld_response_path) }
    it { is_expected.to validate_presence_of(:nld_user) }
    it { is_expected.to validate_presence_of(:nld_password) }
    it { is_expected.to validate_presence_of(:npd_wsdl) }
    it { is_expected.to validate_presence_of(:npd_operation) }
    it { is_expected.to validate_presence_of(:npd_response_path) }
    it { is_expected.to validate_presence_of(:npd_user) }
    it { is_expected.to validate_presence_of(:npd_password) }
    it { is_expected.to validate_presence_of(:budget_balance_wsdl) }
    it { is_expected.to validate_presence_of(:budget_balance_operation) }
    it { is_expected.to validate_presence_of(:budget_balance_response_path) }
    it { is_expected.to validate_presence_of(:budget_balance_user) }
    it { is_expected.to validate_presence_of(:budget_balance_password) }
    it { is_expected.to validate_presence_of(:schedule) }

    describe 'started_at needs to be before finished_at' do

      it 'blanks' do
        expect(configuration.valid?).to be_truthy
      end

      it 'same' do
        configuration.started_at = Date.yesterday
        configuration.finished_at = Date.yesterday
        expect(configuration.valid?).to be_truthy
      end

      it 'started_at before finished_at' do
        configuration.started_at = Date.yesterday
        configuration.finished_at = Date.today
        expect(configuration.valid?).to be_truthy
      end

      it 'started_at after finished_at' do
        configuration.started_at = Date.today
        configuration.finished_at = Date.yesterday
        expect(configuration.valid?).to be_falsey
        expect(configuration.errors.added?(:finished_at, :youngest)).to be_truthy
      end
    end
  end

  describe 'enums' do
    it 'status' do
      statuses = [:status_queued, :status_in_progress, :status_success, :status_fail]
      is_expected.to define_enum_for(:status).with_values(statuses)
    end
  end

  describe 'helpers' do
    it 'title' do
      expect(configuration.title).to eq configuration.model_name.human
    end

    it 'status_str' do
      configuration.status_success!
      expect(configuration.status_str).to eq I18n.t("integration/base_configuration.statuses.status_success")
    end
  end
end
