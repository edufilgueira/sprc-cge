require 'rails_helper'

describe Integration::Contracts::Infringement do

  subject(:integration_contracts_infringement) { build(:integration_contracts_infringement) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_contracts_infringement, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:cod_financiador).of_type(:string) }
      it { is_expected.to have_db_column(:cod_gestora).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_entidade).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_financiador).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_motivo_inadimplencia).of_type(:string) }
      it { is_expected.to have_db_column(:data_lancamento).of_type(:datetime) }
      it { is_expected.to have_db_column(:data_processamento).of_type(:datetime) }
      it { is_expected.to have_db_column(:data_termino_atual).of_type(:datetime) }
      it { is_expected.to have_db_column(:data_ultima_pcontas).of_type(:datetime) }
      it { is_expected.to have_db_column(:data_ultima_pagto).of_type(:datetime) }
      it { is_expected.to have_db_column(:isn_sic).of_type(:integer) }
      it { is_expected.to have_db_column(:qtd_pagtos).of_type(:integer) }
      it { is_expected.to have_db_column(:valor_atualizado_total).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_inadimplencia).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_liberacoes).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_pcontas_acomprovar).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_pcontas_apresentada).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_pcontas_aprovada).of_type(:decimal) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:data_lancamento) }
    it { is_expected.to validate_presence_of(:data_processamento) }
    it { is_expected.to validate_presence_of(:data_termino_atual) }
    it { is_expected.to validate_presence_of(:data_ultima_pcontas) }
    it { is_expected.to validate_presence_of(:data_ultima_pagto) }
    it { is_expected.to validate_presence_of(:isn_sic) }
    it { is_expected.to validate_presence_of(:qtd_pagtos) }
    it { is_expected.to validate_presence_of(:valor_atualizado_total) }
    it { is_expected.to validate_presence_of(:valor_inadimplencia) }
    it { is_expected.to validate_presence_of(:valor_liberacoes) }
    it { is_expected.to validate_presence_of(:valor_pcontas_acomprovar) }
    it { is_expected.to validate_presence_of(:valor_pcontas_apresentada) }
    it { is_expected.to validate_presence_of(:valor_pcontas_aprovada) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:contract) }
  end

  describe 'helpers' do
    it 'sorted' do
      first_unsorted = create(:integration_contracts_infringement, data_lancamento: Date.today)
      last_unsorted = create(:integration_contracts_infringement,  data_lancamento: Date.yesterday)
      expect(Integration::Contracts::Infringement.sorted).to eq([last_unsorted, first_unsorted])
    end

    it 'title' do
      expect(integration_contracts_infringement.title).to eq(integration_contracts_infringement.cod_financiador)
    end
  end

  describe 'convenant' do
    it 'belong_to convenant' do
      convenant = create(:integration_contracts_convenant)
      infringement = integration_contracts_infringement

      infringement.contract = convenant
      infringement.save

      infringement.reload

      expect(infringement.contract).to eq(convenant)
    end
  end
end
