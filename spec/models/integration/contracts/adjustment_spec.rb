require 'rails_helper'

describe Integration::Contracts::Adjustment do

  subject(:integration_contracts_adjustment) { build(:integration_contracts_adjustment) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_contracts_adjustment, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:descricao_observacao).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_tipo_ajuste).of_type(:string) }
      it { is_expected.to have_db_column(:data_ajuste).of_type(:datetime) }
      it { is_expected.to have_db_column(:data_alteracao).of_type(:datetime) }
      it { is_expected.to have_db_column(:data_exclusao).of_type(:datetime) }
      it { is_expected.to have_db_column(:data_inclusao).of_type(:datetime) }
      it { is_expected.to have_db_column(:data_inicio).of_type(:datetime) }
      it { is_expected.to have_db_column(:data_termino).of_type(:datetime) }
      it { is_expected.to have_db_column(:flg_acrescimo_reducao).of_type(:integer) }
      it { is_expected.to have_db_column(:flg_controle_transmissao).of_type(:integer) }
      it { is_expected.to have_db_column(:flg_receita_despesa).of_type(:integer) }
      it { is_expected.to have_db_column(:flg_tipo_ajuste).of_type(:integer) }
      it { is_expected.to have_db_column(:isn_contrato_ajuste).of_type(:integer) }
      it { is_expected.to have_db_column(:isn_contrato_tipo_ajuste).of_type(:integer) }
      it { is_expected.to have_db_column(:ins_edital).of_type(:integer) }
      it { is_expected.to have_db_column(:isn_sic).of_type(:integer) }
      it { is_expected.to have_db_column(:isn_situacao).of_type(:integer) }
      it { is_expected.to have_db_column(:isn_usuario_alteracao).of_type(:integer) }
      it { is_expected.to have_db_column(:isn_usuario_aprovacao).of_type(:integer) }
      it { is_expected.to have_db_column(:isn_usuario_auditoria).of_type(:integer) }
      it { is_expected.to have_db_column(:isn_usuario_exclusao).of_type(:integer) }
      it { is_expected.to have_db_column(:valor_ajuste_destino).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_ajuste_origem).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_inicio_destino).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_inicio_origem).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_termino_origem).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_termino_destino).of_type(:decimal) }
      it { is_expected.to have_db_column(:descricao_url).of_type(:string) }
      it { is_expected.to have_db_column(:num_apostilamento_siconv).of_type(:string) }

      # Data utilizada para atualizações diárias de contratos. O serviço
      # recebe esse parâmetro e retorna os aditivos alterados após essa data.
      # Desse forma, podemos otimizar a atualização diária de aditivos em vez
      # de carregar todos os aditivos.
      it { is_expected.to have_db_column(:data_auditoria).of_type(:date) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:data_ajuste) }
      it { is_expected.to have_db_index(:data_alteracao) }
      it { is_expected.to have_db_index(:data_exclusao) }
      it { is_expected.to have_db_index(:data_inclusao) }
      it { is_expected.to have_db_index(:data_inicio) }
      it { is_expected.to have_db_index(:data_termino) }
      it { is_expected.to have_db_index(:flg_acrescimo_reducao) }
      it { is_expected.to have_db_index(:flg_controle_transmissao) }
      it { is_expected.to have_db_index(:flg_receita_despesa) }
      it { is_expected.to have_db_index(:flg_tipo_ajuste) }
      it { is_expected.to have_db_index(:isn_contrato_ajuste) }
      it { is_expected.to have_db_index(:isn_contrato_tipo_ajuste) }
      it { is_expected.to have_db_index(:ins_edital) }
      it { is_expected.to have_db_index(:isn_sic) }
      it { is_expected.to have_db_index(:isn_situacao) }
      it { is_expected.to have_db_index(:isn_usuario_alteracao) }
      it { is_expected.to have_db_index(:isn_usuario_aprovacao) }
      it { is_expected.to have_db_index(:isn_usuario_auditoria) }
      it { is_expected.to have_db_index(:isn_usuario_exclusao) }
      it { is_expected.to have_db_index(:num_apostilamento_siconv) }
      it { is_expected.to have_db_index(:data_auditoria) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:data_ajuste) }
    it { is_expected.to validate_presence_of(:data_inclusao) }
    it { is_expected.to validate_presence_of(:data_inicio) }
    it { is_expected.to validate_presence_of(:flg_acrescimo_reducao) }
    it { is_expected.to validate_presence_of(:flg_controle_transmissao) }
    it { is_expected.to validate_presence_of(:flg_receita_despesa) }
    it { is_expected.to validate_presence_of(:flg_tipo_ajuste) }
    it { is_expected.to validate_presence_of(:isn_contrato_ajuste) }
    it { is_expected.to validate_presence_of(:isn_contrato_tipo_ajuste) }
    it { is_expected.to validate_presence_of(:ins_edital) }
    it { is_expected.to validate_presence_of(:isn_sic) }
    it { is_expected.to validate_presence_of(:isn_situacao) }
    it { is_expected.to validate_presence_of(:isn_usuario_alteracao) }
    it { is_expected.to validate_presence_of(:isn_usuario_aprovacao) }
    it { is_expected.to validate_presence_of(:isn_usuario_auditoria) }
    it { is_expected.to validate_presence_of(:isn_usuario_exclusao) }
    it { is_expected.to validate_presence_of(:valor_ajuste_destino) }
    it { is_expected.to validate_presence_of(:valor_ajuste_origem) }
    it { is_expected.to validate_presence_of(:valor_inicio_destino) }
    it { is_expected.to validate_presence_of(:valor_inicio_origem) }
    it { is_expected.to validate_presence_of(:valor_termino_origem) }
    it { is_expected.to validate_presence_of(:valor_termino_destino) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:contract) }
  end

  describe 'scope' do
    it 'sorted' do
      first_unsorted = create(:integration_contracts_adjustment, data_ajuste: Date.today)
      last_unsorted = create(:integration_contracts_adjustment,  data_ajuste: Date.yesterday)
      expect(Integration::Contracts::Adjustment.sorted).to eq([last_unsorted, first_unsorted])
    end

    it 'total_adjustments' do
      create_list(:integration_contracts_adjustment, 2)

      expected = Integration::Contracts::Adjustment.sum(:valor_ajuste_origem) + Integration::Contracts::Adjustment.sum(:valor_ajuste_destino)

      expect(Integration::Contracts::Adjustment.total_adjustments).to eq(expected)
    end
  end

  describe 'helpers' do
    it 'title' do
      expect(integration_contracts_adjustment.title).to eq(integration_contracts_adjustment.isn_contrato_ajuste.to_s)
    end

    it 'total_ajuste' do
      adjustment = create(:integration_contracts_adjustment, valor_ajuste_destino: 1, valor_ajuste_origem: 1)

      expect(adjustment.total_adjustment).to eq(2)
    end
  end

  describe 'convenant' do
    it 'belong_to convenant' do
      convenant = create(:integration_contracts_convenant)
      adjustment = integration_contracts_adjustment

      adjustment.contract = convenant
      adjustment.save

      adjustment.reload

      expect(adjustment.contract).to eq(convenant)
    end
  end

  describe 'callbacks' do
    it 'notify_create' do
      adjustment = create(:integration_contracts_adjustment)

      expect(adjustment.utils_data_change.new_resource_notificable?).to be_truthy
      expect(adjustment.data_changes).to eq(nil)
    end
  end
end
