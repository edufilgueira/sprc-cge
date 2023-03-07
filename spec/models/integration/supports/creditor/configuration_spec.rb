require 'rails_helper'

describe Integration::Supports::Creditor::Configuration do

  subject(:configuration) { build(:integration_supports_creditor_configuration) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_creditor_configuration, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:wsdl).of_type(:string) }
      it { is_expected.to have_db_column(:headers_soap_action).of_type(:string) }
      it { is_expected.to have_db_column(:user).of_type(:string) }
      it { is_expected.to have_db_column(:password).of_type(:string) }
      it { is_expected.to have_db_column(:operation).of_type(:string) }
      it { is_expected.to have_db_column(:started_at).of_type(:date) }
      it { is_expected.to have_db_column(:finished_at).of_type(:date) }
      it { is_expected.to have_db_column(:response_path).of_type(:string) }
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
    it { is_expected.to validate_presence_of(:wsdl) }
    it { is_expected.to_not validate_presence_of(:headers_soap_action) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_presence_of(:operation) }
    it { is_expected.to validate_presence_of(:response_path) }
    it { is_expected.to validate_presence_of(:schedule) }

    describe 'start time needs to be before finish time' do

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
