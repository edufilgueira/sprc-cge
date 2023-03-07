require 'rails_helper'

describe Integration::Contracts::Additive do

  subject(:integration_contracts_additive) { build(:integration_contracts_additive) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_contracts_additive, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:descricao_observacao).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_tipo_aditivo).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_url).of_type(:string) }
      it { is_expected.to have_db_column(:data_aditivo).of_type(:datetime) }
      it { is_expected.to have_db_column(:data_inicio).of_type(:datetime) }
      it { is_expected.to have_db_column(:data_publicacao).of_type(:datetime) }
      it { is_expected.to have_db_column(:data_termino).of_type(:datetime) }
      it { is_expected.to have_db_column(:flg_tipo_aditivo).of_type(:integer) }
      it { is_expected.to have_db_column(:isn_contrato_aditivo).of_type(:integer) }
      it { is_expected.to have_db_column(:isn_ig).of_type(:integer) }
      it { is_expected.to have_db_column(:isn_sic).of_type(:integer) }
      it { is_expected.to have_db_column(:valor_acrescimo).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_reducao).of_type(:decimal) }
      it { is_expected.to have_db_column(:data_publicacao_portal).of_type(:datetime) }
      it { is_expected.to have_db_column(:num_aditivo_siconv).of_type(:string) }

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
      it { is_expected.to have_db_index(:data_aditivo) }
      it { is_expected.to have_db_index(:data_inicio) }
      it { is_expected.to have_db_index(:data_publicacao) }
      it { is_expected.to have_db_index(:data_termino) }
      it { is_expected.to have_db_index(:flg_tipo_aditivo) }
      it { is_expected.to have_db_index(:isn_contrato_aditivo) }
      it { is_expected.to have_db_index(:isn_ig) }
      it { is_expected.to have_db_index(:isn_sic) }
      it { is_expected.to have_db_index(:data_publicacao_portal) }
      it { is_expected.to have_db_index(:num_aditivo_siconv) }
      it { is_expected.to have_db_index(:data_auditoria) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:data_aditivo) }
    it { is_expected.to validate_presence_of(:data_inicio) }
    it { is_expected.to validate_presence_of(:data_publicacao) }
    it { is_expected.to validate_presence_of(:data_termino) }
    it { is_expected.to validate_presence_of(:flg_tipo_aditivo) }
    it { is_expected.to validate_presence_of(:isn_contrato_aditivo) }
    it { is_expected.to validate_presence_of(:isn_ig) }
    it { is_expected.to validate_presence_of(:isn_sic) }
    it { is_expected.to validate_presence_of(:valor_acrescimo) }
    it { is_expected.to validate_presence_of(:valor_reducao) }
    it { is_expected.to validate_presence_of(:data_publicacao_portal) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:contract) }
  end

   describe 'scope' do
    it 'credit' do
      addition = create(:integration_contracts_additive)
      extension_addition = create(:integration_contracts_additive, :extension_addition)
      create(:integration_contracts_additive, :reduction)

      expect(Integration::Contracts::Additive.credit).to eq([addition, extension_addition])
    end

    it 'credit_sum' do
      addition = create(:integration_contracts_additive)
      extension_addition = create(:integration_contracts_additive, :extension_addition)
      create(:integration_contracts_additive, :reduction)

      expected = addition.valor_acrescimo + extension_addition.valor_acrescimo

      expect(Integration::Contracts::Additive.credit_sum).to eq(expected)
    end

    it 'credit_sum' do
      reduction = create(:integration_contracts_additive, :reduction)
      other_reduction = create(:integration_contracts_additive, :reduction)
      create(:integration_contracts_additive, :extension_addition)

      expected = reduction.valor_reducao + other_reduction.valor_reducao

      expect(Integration::Contracts::Additive.reduction_sum).to eq(expected)
    end

    it 'total_addition' do
      reduction = create(:integration_contracts_additive, :reduction)
      addition = create(:integration_contracts_additive)
      extension_addition = create(:integration_contracts_additive, :extension_addition)

      expected = addition.valor_acrescimo + extension_addition.valor_acrescimo - reduction.valor_reducao

      expect(Integration::Contracts::Additive.total_addition).to eq(expected)
    end
  end

  describe 'helpers' do
    it 'title' do
      expect(integration_contracts_additive.title).to eq(integration_contracts_additive.isn_contrato_aditivo.to_s)
    end
  end

  describe 'convenant' do
    it 'belong_to convenant' do
      convenant = create(:integration_contracts_convenant, isn_sic: '1234')

      additive = build(:integration_contracts_additive, contract: convenant, isn_sic: convenant.isn_sic)
      additive.save

      additive.reload

      expect(additive.contract).to eq(convenant)
    end
  end

  describe 'callbacks' do
    it 'notify_create' do
      additive = create(:integration_contracts_additive)

      expect(additive.utils_data_change.new_resource_notificable?).to be_truthy
      expect(additive.data_changes).to eq(nil)
    end
  end
end
