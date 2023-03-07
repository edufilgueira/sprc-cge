require 'rails_helper'

describe Integration::Servers::Configuration do

  subject(:configuration) { build(:integration_servers_configuration) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_servers_configuration, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:arqfun_ftp_address).of_type(:string) }
      it { is_expected.to have_db_column(:arqfun_ftp_passive).of_type(:boolean) }
      it { is_expected.to have_db_column(:arqfun_ftp_dir).of_type(:string) }
      it { is_expected.to have_db_column(:arqfun_ftp_user).of_type(:string) }
      it { is_expected.to have_db_column(:arqfun_ftp_password).of_type(:string) }
      it { is_expected.to have_db_column(:arqfin_ftp_address).of_type(:string) }
      it { is_expected.to have_db_column(:arqfin_ftp_passive).of_type(:boolean) }
      it { is_expected.to have_db_column(:arqfin_ftp_dir).of_type(:string) }
      it { is_expected.to have_db_column(:arqfin_ftp_user).of_type(:string) }
      it { is_expected.to have_db_column(:arqfin_ftp_password).of_type(:string) }
      it { is_expected.to have_db_column(:rubricas_ftp_address).of_type(:string) }
      it { is_expected.to have_db_column(:rubricas_ftp_passive).of_type(:boolean) }
      it { is_expected.to have_db_column(:rubricas_ftp_dir).of_type(:string) }
      it { is_expected.to have_db_column(:rubricas_ftp_user).of_type(:string) }
      it { is_expected.to have_db_column(:rubricas_ftp_password).of_type(:string) }
      it { is_expected.to have_db_column(:status).of_type(:integer) }
      it { is_expected.to have_db_column(:last_importation).of_type(:datetime) }
      it { is_expected.to have_db_column(:log).of_type(:string) }
      it { is_expected.to have_db_column(:month).of_type(:string) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:arqfun_ftp_address) }
    it { is_expected.to validate_presence_of(:arqfun_ftp_user) }
    it { is_expected.to validate_presence_of(:arqfun_ftp_password) }
    it { is_expected.to validate_presence_of(:arqfin_ftp_address) }
    it { is_expected.to validate_presence_of(:arqfin_ftp_user) }
    it { is_expected.to validate_presence_of(:arqfin_ftp_password) }
    it { is_expected.to validate_presence_of(:rubricas_ftp_address) }
    it { is_expected.to validate_presence_of(:rubricas_ftp_user) }
    it { is_expected.to validate_presence_of(:rubricas_ftp_password) }
    it { is_expected.to validate_presence_of(:schedule) }
  end

  describe 'associations' do
    it { is_expected.to have_one(:schedule) }
  end

  describe 'nested' do
    it { is_expected.to accept_nested_attributes_for(:schedule).allow_destroy(true) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:cron_syntax_frequency).to(:schedule) }
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

    it 'current_month' do
      # Se algum mês específico estiver definido, todo o processo de download,
      # registro e consolidação dos dados será feito para o mês.
      # Caso o campo mês esteja em branco, será considerado o mês corrente.

      configuration.month = '09/2017'
      expected = configuration.month
      expect(configuration.current_month).to eq(expected)

      configuration.month = nil
      expected = I18n.l(Date.today, format: :month_year)
      expect(configuration.current_month).to eq(expected)
    end

    describe 'download_path' do
      let(:configuration_year) { configuration.current_month.split('/')[1] }
      let(:configuration_month) { configuration.current_month.split('/')[0] }
      let(:year_month) { "#{configuration_year}#{configuration_month}" }

      before do
        # Importante para não alterar o filesystem padrão!
        allow(Rails).to receive(:root).and_return(Dir.mktmpdir)

        FileUtils.rm_rf(Rails.root.to_s + "/files/integration/servers/*")
      end

      it 'creates download_path if does not exist' do
        configuration.save

        download_path = Rails.root.to_s + "/files/integration/servers/#{configuration.id}/#{year_month}/"

        expect(Dir.exist?(download_path)).to eq(false)

        result = configuration.download_path

        expect(Dir.exist?(download_path)).to eq(true)
        expect(result).to eq(download_path)
      end

      it 'does not create and return nil for new configurations' do
        configuration.id = nil
        result = configuration.download_path

        expect(result).to eq(nil)
        error_path = Rails.root.to_s + "/files/integration/servers//#{year_month}/"
        expect(Dir.exist?(error_path)).to eq(false)
      end
    end
  end
end
