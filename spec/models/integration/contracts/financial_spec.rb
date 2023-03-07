require 'rails_helper'

describe Integration::Contracts::Financial do

  subject(:integration_contracts_financial) { build(:integration_contracts_financial) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_contracts_financial, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:ano_documento).of_type(:string) }
      it { is_expected.to have_db_column(:cod_entidade).of_type(:integer) }
      it { is_expected.to have_db_column(:cod_fonte).of_type(:integer) }
      it { is_expected.to have_db_column(:cod_gestor).of_type(:integer) }
      it { is_expected.to have_db_column(:descricao_entidade).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_objeto).of_type(:string) }
      it { is_expected.to have_db_column(:data_documento).of_type(:datetime) }
      it { is_expected.to have_db_column(:data_pagamento).of_type(:datetime) }
      it { is_expected.to have_db_column(:data_processamento).of_type(:datetime) }
      it { is_expected.to have_db_column(:flg_sic).of_type(:integer) }
      it { is_expected.to have_db_column(:isn_sic).of_type(:integer) }
      it { is_expected.to have_db_column(:num_pagamento).of_type(:string) }
      it { is_expected.to have_db_column(:num_documento).of_type(:string) }
      it { is_expected.to have_db_column(:valor_documento).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_pagamento).of_type(:decimal) }
      it { is_expected.to have_db_column(:cod_credor).of_type(:string) }

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
      it { is_expected.to have_db_index(:ano_documento) }
      it { is_expected.to have_db_index(:cod_entidade) }
      it { is_expected.to have_db_index(:cod_fonte) }
      it { is_expected.to have_db_index(:cod_gestor) }
      it { is_expected.to have_db_index(:data_documento) }
      it { is_expected.to have_db_index(:data_pagamento) }
      it { is_expected.to have_db_index(:data_processamento) }
      it { is_expected.to have_db_index(:flg_sic) }
      it { is_expected.to have_db_index(:isn_sic) }
      it { is_expected.to have_db_index(:num_pagamento) }
      it { is_expected.to have_db_index(:num_documento) }
      it { is_expected.to have_db_index(:cod_credor) }
      it { is_expected.to have_db_index(:data_auditoria) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:contract) }

    it { is_expected.to have_one(:ned).with_foreign_key(:numero).with_primary_key(:num_documento) }
    it { is_expected.to have_one(:npf).with_foreign_key(:numero).with_primary_key(:num_pagamento) }

    it 'has_one ned with same unidade gestora' do
      # A chave em NED é numero + unidade_gestora + exercicio. Há mais de uma ned com mesmo número.

      ned = create(:integration_expenses_ned, numero: '1234', exercicio: 2010, unidade_gestora: '1234')
      financial = create(:integration_contracts_financial, num_documento: '1234', ano_documento: 2010, cod_gestor: 123)

      expect(financial.ned).to be_nil

      financial.cod_gestor = 1234
      financial.save
      financial.reload

      expect(financial.ned).to eq(ned)

      financial.ano_documento = 2009
      financial.save
      financial.reload

      expect(financial.ned).to be_nil
    end

    it 'has_one npf with same unidade gestora' do
      # A chave em NPF é numero + unidade_gestora. Há mais de uma npf com mesmo número.

      npf = create(:integration_expenses_npf, numero: '1234', exercicio: 2010, unidade_gestora: '1234')
      financial = create(:integration_contracts_financial, num_pagamento: '1234', ano_documento: 2010, cod_gestor: 123)

      expect(financial.npf).to be_nil

      financial.cod_gestor = 1234
      financial.save
      financial.reload

      expect(financial.npf).to eq(npf)

      financial.ano_documento = 2009
      financial.save
      financial.reload

      expect(financial.npf).to be_nil
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:cod_entidade) }
    it { is_expected.to validate_presence_of(:cod_fonte) }
    it { is_expected.to validate_presence_of(:cod_gestor) }
    it { is_expected.to validate_presence_of(:data_documento) }
    it { is_expected.to validate_presence_of(:data_pagamento) }
    it { is_expected.to validate_presence_of(:data_processamento) }
    it { is_expected.to validate_presence_of(:flg_sic) }
    it { is_expected.to validate_presence_of(:isn_sic) }
    it { is_expected.to validate_presence_of(:valor_documento) }
    it { is_expected.to validate_presence_of(:valor_pagamento) }
  end

  describe 'scope' do
    it 'sorted' do
      first_unsorted = create(:integration_contracts_financial, data_documento: Date.yesterday)
      last_unsorted = create(:integration_contracts_financial,  data_documento: Date.today)
      expect(Integration::Contracts::Financial.sorted).to eq([last_unsorted, first_unsorted])
    end

    it 'document_sum' do
      create_list(:integration_contracts_financial, 2)

      expected = Integration::Contracts::Financial.sum(:valor_documento)

      expect(Integration::Contracts::Financial.document_sum).to eq(expected)
    end

    it 'payment_sum' do
      create_list(:integration_contracts_financial, 2)

      expected = Integration::Contracts::Financial.sum(:valor_pagamento)

      expect(Integration::Contracts::Financial.payment_sum).to eq(expected)
    end
  end

  describe 'helpers' do
    it 'title' do
      expect(integration_contracts_financial.title).to eq(integration_contracts_financial.num_documento.to_s)
    end
  end

  describe 'convenant' do
    it 'belong_to convenant' do
      convenant = create(:integration_contracts_convenant)
      financial = integration_contracts_financial

      financial.contract = convenant
      financial.save

      financial.reload

      expect(financial.contract).to eq(convenant)
    end
  end

  describe 'callbacks' do
    it 'notify_create' do
      financial = create(:integration_contracts_financial)

      expect(financial.utils_data_change.new_resource_notificable?).to be_truthy
      expect(financial.data_changes).to eq(nil)
    end
  end
end
