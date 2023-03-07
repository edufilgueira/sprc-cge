require 'rails_helper'

describe Integration::Contracts::Configuration do

  subject(:configuration) { build(:integration_contracts_configuration) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_contracts_configuration, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:headers_soap_action).of_type(:string) }
      it { is_expected.to have_db_column(:wsdl).of_type(:string) }
      it { is_expected.to have_db_column(:user).of_type(:string) }
      it { is_expected.to have_db_column(:password).of_type(:string) }

      it { is_expected.to have_db_column(:start_at).of_type(:date) }
      it { is_expected.to have_db_column(:end_at).of_type(:date) }

      it { is_expected.to have_db_column(:contract_operation).of_type(:string) }
      it { is_expected.to have_db_column(:contract_response_path).of_type(:string) }
      it { is_expected.to have_db_column(:contract_parameters).of_type(:string) }
      it { is_expected.to have_db_column(:additive_operation).of_type(:string) }
      it { is_expected.to have_db_column(:additive_response_path).of_type(:string) }
      it { is_expected.to have_db_column(:additive_parameters).of_type(:string) }
      it { is_expected.to have_db_column(:adjustment_operation).of_type(:string) }
      it { is_expected.to have_db_column(:adjustment_response_path).of_type(:string) }
      it { is_expected.to have_db_column(:adjustment_parameters).of_type(:string) }
      it { is_expected.to have_db_column(:financial_operation).of_type(:string) }
      it { is_expected.to have_db_column(:financial_response_path).of_type(:string) }
      it { is_expected.to have_db_column(:financial_parameters).of_type(:string) }
      it { is_expected.to have_db_column(:infringement_operation).of_type(:string) }
      it { is_expected.to have_db_column(:infringement_response_path).of_type(:string) }
      it { is_expected.to have_db_column(:infringement_parameters).of_type(:string) }
      it { is_expected.to have_db_column(:status).of_type(:integer) }
      it { is_expected.to have_db_column(:last_importation).of_type(:datetime) }
      it { is_expected.to have_db_column(:log).of_type(:text) }

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
    it { is_expected.to_not validate_presence_of(:headers_soap_action) }
    it { is_expected.to validate_presence_of(:wsdl) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_presence_of(:schedule) }
    it { is_expected.to validate_presence_of(:contract_operation) }
    it { is_expected.to validate_presence_of(:contract_response_path) }
    it { is_expected.to validate_presence_of(:additive_operation) }
    it { is_expected.to validate_presence_of(:additive_response_path) }
    it { is_expected.to validate_presence_of(:adjustment_operation) }
    it { is_expected.to validate_presence_of(:adjustment_response_path) }
    it { is_expected.to validate_presence_of(:financial_operation) }
    it { is_expected.to validate_presence_of(:financial_response_path) }
    it { is_expected.to validate_presence_of(:infringement_operation) }
    it { is_expected.to validate_presence_of(:infringement_response_path) }
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

    it 'import' do
      # @SPRC-DATA tested on sprc-data/spec/models/integration/contracts/configuration_spec.rb
    end

    it 'status_str' do
      configuration.status_success!
      expected = I18n.t("integration/base_configuration.statuses.status_success")

      expect(configuration.status_str).to eq(expected)
    end
  end
end
