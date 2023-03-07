require 'rails_helper'

describe Integration::Eparcerias::Configuration do

  subject(:configuration) { build(:integration_eparcerias_configuration) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_eparcerias_configuration, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:headers_soap_action).of_type(:string) }
      it { is_expected.to have_db_column(:wsdl).of_type(:string) }
      it { is_expected.to have_db_column(:user).of_type(:string) }
      it { is_expected.to have_db_column(:password).of_type(:string) }

      it { is_expected.to have_db_column(:transfer_bank_order_operation).of_type(:string) }
      it { is_expected.to have_db_column(:transfer_bank_order_response_path).of_type(:string) }

      it { is_expected.to have_db_column(:work_plan_attachment_operation).of_type(:string) }
      it { is_expected.to have_db_column(:work_plan_attachment_response_path).of_type(:string) }

      it { is_expected.to have_db_column(:accountability_operation).of_type(:string) }
      it { is_expected.to have_db_column(:accountability_response_path).of_type(:string) }


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
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_presence_of(:schedule) }
    it { is_expected.to validate_presence_of(:transfer_bank_order_operation) }
    it { is_expected.to validate_presence_of(:transfer_bank_order_response_path) }
    it { is_expected.to validate_presence_of(:work_plan_attachment_operation) }
    it { is_expected.to validate_presence_of(:work_plan_attachment_response_path) }
    it { is_expected.to validate_presence_of(:accountability_operation) }
    it { is_expected.to validate_presence_of(:accountability_response_path) }
  end

  describe 'enums' do
    it 'status' do
      statuses = [:status_queued, :status_in_progress, :status_success, :status_fail]
      is_expected.to define_enum_for(:status).with_values(statuses)
    end

    it 'enum' do
      import_types = [:import_all, :import_active]
      is_expected.to define_enum_for(:import_type).with_values(import_types)
    end
  end

  describe 'helpers' do
    it 'title' do
      expect(configuration.title).to eq configuration.model_name.human
    end

    #
    # O status_str é definido em base e por isso não tem a tradução no
    # path desse model ('intragration/eparcerias/configuration.statuses...')
    # Por esse motivo, o funcionamento do EnumLocalizable (status_str)
    # é sobrescrito em integration/base_configuration.
    #
    it 'status_str' do
      configuration.status_success!
      expected = I18n.t("integration/base_configuration.statuses.status_success")

      expect(configuration.status_str).to eq(expected)
    end

    it 'import_type_str' do
      configuration.import_type = :import_all
      expected = I18n.t("integration/eparcerias/configuration.import_types.import_all")

      expect(configuration.import_type_str).to eq(expected)
    end
  end
end
