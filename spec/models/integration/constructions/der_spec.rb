require 'rails_helper'

describe Integration::Constructions::Der do

  subject(:der) { build(:integration_constructions_der) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_constructions_der, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:base).of_type(:string) }
      it { is_expected.to have_db_column(:cerca).of_type(:string) }
      it { is_expected.to have_db_column(:conclusao).of_type(:datetime) }
      it { is_expected.to have_db_column(:construtora).of_type(:string) }
      it { is_expected.to have_db_column(:cor_status).of_type(:string) }
      it { is_expected.to have_db_column(:data_fim_contrato).of_type(:datetime) }
      it { is_expected.to have_db_column(:data_fim_previsto).of_type(:datetime) }
      it { is_expected.to have_db_column(:distrito).of_type(:string) }
      it { is_expected.to have_db_column(:drenagem).of_type(:string) }
      it { is_expected.to have_db_column(:extensao).of_type(:decimal) }
      it { is_expected.to have_db_column(:id_obra).of_type(:integer) }
      it { is_expected.to have_db_column(:numero_contrato_der).of_type(:string) }
      it { is_expected.to have_db_column(:numero_contrato_ext).of_type(:string) }
      it { is_expected.to have_db_column(:numero_contrato_sic).of_type(:string) }
      it { is_expected.to have_db_column(:obra_darte).of_type(:string) }
      it { is_expected.to have_db_column(:percentual_executado).of_type(:integer) }
      it { is_expected.to have_db_column(:programa).of_type(:string) }
      it { is_expected.to have_db_column(:qtd_empregos).of_type(:integer) }
      it { is_expected.to have_db_column(:qtd_geo_referencias).of_type(:integer) }
      it { is_expected.to have_db_column(:revestimento).of_type(:string) }
      it { is_expected.to have_db_column(:rodovia).of_type(:string) }
      it { is_expected.to have_db_column(:servicos).of_type(:string) }
      it { is_expected.to have_db_column(:sinalizacao).of_type(:string) }
      it { is_expected.to have_db_column(:status).of_type(:string) }
      it { is_expected.to have_db_column(:supervisora).of_type(:string) }
      it { is_expected.to have_db_column(:terraplanagem).of_type(:string) }
      it { is_expected.to have_db_column(:trecho).of_type(:string) }
      it { is_expected.to have_db_column(:ult_atual).of_type(:datetime) }
      it { is_expected.to have_db_column(:valor_aprovado).of_type(:decimal) }


      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:id_obra) }
    it { is_expected.to validate_presence_of(:servicos) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:measurements).class_name('Integration::Constructions::Der::Measurement') }

    it do
      is_expected.to have_one(:utils_data_change).class_name('Integration::Utils::DataChange')
    end
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:data_changes).to(:utils_data_change).with_arguments(allow_nil: true) }
    it { is_expected.to delegate_method(:resource_status).to(:utils_data_change).with_arguments(allow_nil: true) }
  end

  describe 'enums' do
    it 'der_status' do
      statuses = [
        :canceled,
        :done,
        :in_progress,
        :in_project,
        :in_bidding,
        :not_started,
        :paused,
        :project_done,
        :bid
      ]

      is_expected.to define_enum_for(:der_status).with_values(statuses)
    end
  end

  describe 'helpers' do
    it 'title' do
      expected = "#{der.id_obra.to_s} - #{der.servicos.truncate(30)}"

      expect(der.title).to eq(expected)
    end

    it 'der_status_str' do
      expected = I18n.t("integration/constructions/der.der_statuses.#{der.der_status}")

      expect(der.der_status_str).to eq(expected)
    end
  end

  describe 'scopes' do
    describe 'data_fim_contrato_in_range' do
      let!(:der_in_range) do
        create(:integration_constructions_der, data_fim_contrato: Date.today)
      end

      let!(:old_der) do
        create(:integration_constructions_der, data_fim_contrato: (Date.today-2.day))
      end

      let!(:new_der) do
        create(:integration_constructions_der, data_fim_contrato: (Date.today+2.day))
      end

      it do
        expect(described_class.data_fim_contrato_in_range(Date.yesterday, Date.tomorrow))
        .to eq [der_in_range]
      end
    end

    describe 'data_fim_previsto_in_range' do
      let!(:der_in_range) do
        create(:integration_constructions_der, data_fim_previsto: Date.today)
      end

      let!(:old_der) do
        create(:integration_constructions_der, data_fim_previsto: (Date.today-2.day))
      end

      let!(:new_der) do
        create(:integration_constructions_der, data_fim_previsto: (Date.today+2.day))
      end

      it do
        expect(described_class.data_fim_previsto_in_range(Date.yesterday, Date.tomorrow))
        .to eq [der_in_range]
      end
    end
  end

  describe 'callbacks' do
    describe 'create_last_changes' do
      it 'change percentual_executado' do
        der.update(percentual_executado: 50)
        changes_notificables = { 'percentual_executado'=>[50, 80] }

        der.save

        der.update(percentual_executado: 80)

        expect(der.data_changes).to eq(changes_notificables)
        expect(der.resource_status).to eq('updated_resource_notificable')
      end
    end
  end
end
