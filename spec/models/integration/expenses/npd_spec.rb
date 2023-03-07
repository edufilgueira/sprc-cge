require 'rails_helper'

describe Integration::Expenses::Npd do

  subject(:integration_expenses_npd) { build(:integration_expenses_npd) }

  let(:npd) { integration_expenses_npd }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_expenses_npd, :invalid)).to be_invalid }
  end

  it_behaves_like 'models/integration/expenses/base'

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:exercicio).of_type(:integer) }
      it { is_expected.to have_db_column(:unidade_gestora).of_type(:string) }
      it { is_expected.to have_db_column(:unidade_executora).of_type(:string) }
      it { is_expected.to have_db_column(:numero).of_type(:string) }
      it { is_expected.to have_db_column(:numero_npd_ordinaria).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_localidade_npd_ordinaria).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_retencao).of_type(:string) }
      it { is_expected.to have_db_column(:natureza).of_type(:string) }
      it { is_expected.to have_db_column(:justificativa).of_type(:string) }
      it { is_expected.to have_db_column(:efeito).of_type(:string) }
      it { is_expected.to have_db_column(:numero_processo_administrativo_despesa).of_type(:string) }
      it { is_expected.to have_db_column(:data_emissao).of_type(:string) }
      it { is_expected.to have_db_column(:credor).of_type(:string) }
      it { is_expected.to have_db_column(:documento_credor).of_type(:string) }
      it { is_expected.to have_db_column(:valor).of_type(:decimal) }
      it { is_expected.to have_db_column(:numero_nld_ordinaria).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_natureza_receita).of_type(:string) }
      it { is_expected.to have_db_column(:servico_bancario).of_type(:string) }
      it { is_expected.to have_db_column(:banco_origem).of_type(:string) }
      it { is_expected.to have_db_column(:agencia_origem).of_type(:string) }
      it { is_expected.to have_db_column(:digito_agencia_origem).of_type(:string) }
      it { is_expected.to have_db_column(:conta_origem).of_type(:string) }
      it { is_expected.to have_db_column(:digito_conta_origem).of_type(:string) }
      it { is_expected.to have_db_column(:banco_pagamento).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_localidade).of_type(:string) }
      it { is_expected.to have_db_column(:banco_beneficiario).of_type(:string) }
      it { is_expected.to have_db_column(:agencia_beneficiario).of_type(:string) }
      it { is_expected.to have_db_column(:digito_agencia_beneficiario).of_type(:string) }
      it { is_expected.to have_db_column(:conta_beneficiario).of_type(:string) }
      it { is_expected.to have_db_column(:digito_conta_beneficiario).of_type(:string) }
      it { is_expected.to have_db_column(:status_movimento_bancario).of_type(:string) }
      it { is_expected.to have_db_column(:data_retorno_remessa_bancaria).of_type(:string) }
      it { is_expected.to have_db_column(:processo_judicial).of_type(:string) }
      it { is_expected.to have_db_column(:data_atual).of_type(:string) }

      it { is_expected.to have_db_column(:date_of_issue).of_type(:date) }

      # Colunas de chave composta para associações diretas de NED com NLD e NPD

      it { is_expected.to have_db_column(:nld_composed_key).of_type(:string) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      # Índices básicos dos componentes da chave
      it { is_expected.to have_db_index(:exercicio) }
      it { is_expected.to have_db_index(:unidade_gestora) }
      it { is_expected.to have_db_index(:unidade_executora) }
      it { is_expected.to have_db_index(:numero) }
      it { is_expected.to have_db_index(:natureza) }

      it { is_expected.to have_db_index(:servico_bancario) }

      # Índices de associações
      it { is_expected.to have_db_index(:numero_nld_ordinaria) }
      it { is_expected.to have_db_index(:numero_npd_ordinaria) }
      it { is_expected.to have_db_index(:credor) }

      it { is_expected.to have_db_index([:exercicio, :unidade_gestora, :numero]) }

      it { is_expected.to have_db_index(:nld_composed_key) }
    end
  end

  describe 'associations' do

    it { is_expected.to belong_to(:management_unit).with_foreign_key(:unidade_gestora).with_primary_key(:codigo) }
    it { is_expected.to belong_to(:executing_unit).with_foreign_key(:unidade_executora).with_primary_key(:codigo) }
    it { is_expected.to belong_to(:creditor).with_foreign_key(:credor).with_primary_key(:codigo) }
    it { is_expected.to belong_to(:nld).with_foreign_key(:nld_composed_key).with_primary_key(:composed_key) }

    it { is_expected.to have_one(:payment_retention_type).with_foreign_key(:codigo_retencao).with_primary_key(:codigo_retencao) }
    it { is_expected.to have_one(:revenue_nature).with_foreign_key(:codigo_natureza_receita).with_primary_key(:codigo) }


    #
    # Associação com NPD deve utilizar as colunas já existentes para evitar
    # finds no importador
    #
    it 'belongs_to npd_ordinaria' do
      npd.exercicio = 2010
      npd.unidade_gestora = 1234
      npd.numero_npd_ordinaria = 5678

      # Esses registros não devem ser associados pois tem exercicio ou unidade_gestora distinta
      another_npd = create(:integration_expenses_npd, exercicio: 2011, unidade_gestora: 1234, numero: 5678)
      yet_another_npd = create(:integration_expenses_npd, exercicio: 2010, unidade_gestora: 9999, numero: 5678)

      # importante criar essa por último para garantir que todos os atributos
      # estão sendo considerados na associação.
      npd_ordinaria = create(:integration_expenses_npd, exercicio: 2010, unidade_gestora: 1234, numero: 5678)

      expect(npd.npd_ordinaria).to eq(npd_ordinaria)
    end

    #
    # Associação com NLD deve utilizar as colunas já existentes para evitar
    # finds no importador
    #
    it 'belongs_to nld' do
      npd.exercicio = 2010
      npd.unidade_gestora = 1234
      npd.numero_nld_ordinaria = 5678

      # Esses registros não devem ser associados pois tem exercicio ou unidade_gestora distinta
      another_nld = create(:integration_expenses_nld, exercicio: 2011, unidade_gestora: 1234, numero: 5678)
      yet_another_nld = create(:integration_expenses_nld, exercicio: 2010, unidade_gestora: 9999, numero: 5678)

      # importante criar essa por último para garantir que todos os atributos
      # estão sendo considerados na associação.
      nld = create(:integration_expenses_nld, exercicio: 2010, unidade_gestora: 1234, numero: 5678)

      npd.save

      expect(npd.nld).to eq(nld)
    end

    it 'has_many npds' do
      npd.exercicio = 2010
      npd.unidade_gestora = 1234
      npd.numero = 5678

      # Esses registros não devem ser associados pois tem exercicio ou unidade_gestora distinta
      another_npd = create(:integration_expenses_npd, exercicio: 2011, unidade_gestora: 1234, numero_npd_ordinaria: 5678)
      yet_another_npd = create(:integration_expenses_npd, exercicio: 2010, unidade_gestora: 9999, numero_npd_ordinaria: 5678)

      # importante criar essa por último para garantir que todos os atributos
      # estão sendo considerados na associação.
      first_npd = create(:integration_expenses_npd, exercicio: 2010, unidade_gestora: 1234, numero_npd_ordinaria: 5678)
      second_npd = create(:integration_expenses_npd, exercicio: 2010, unidade_gestora: 1234, numero_npd_ordinaria: 5678)

      expect(npd.npds).to match_array([first_npd, second_npd])
    end

  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:exercicio) }
    it { is_expected.to validate_presence_of(:unidade_gestora) }
    it { is_expected.to validate_presence_of(:numero) }

    it { is_expected.to validate_presence_of(:numero_nld_ordinaria) }
  end

  describe 'helpers' do
    it 'valor_final' do
      npd = create(:integration_expenses_npd, { valor: 50 })

      suplementado_npd = create(:integration_expenses_npd, { natureza: 'Suplementação', npd_ordinaria: npd, valor: 10 })
      anulado_npd = create(:integration_expenses_npd, { natureza: 'Anulação', npd_ordinaria: npd, valor: 5 })


      expect(npd.valor_final).to eq(55)
    end
  end

  describe 'after_validation' do
    it 'sets nld_composed_key' do
      expected = "#{npd.exercicio}#{npd.unidade_gestora}#{npd.numero_nld_ordinaria}"
      npd.valid?

      expect(npd.nld_composed_key).to eq(expected)
    end

    it 'sets daily' do
      npd = create(:integration_expenses_daily)
      expect(npd).to be_daily
    end
  end

  describe 'after_commit' do
    describe 'calculated columns' do
      it 'calculated_valor_pago_apos_exercicio on parent ned'  do
        # Precisamos atualizar os valores pagos da NED

        npd.exercicio = 2011
        npd.unidade_gestora = 1234
        npd.numero_nld_ordinaria = 5678

        nld = create(:integration_expenses_nld, exercicio: 2011, exercicio_restos_a_pagar: 2010, unidade_gestora: 1234, numero: 5678, numero_nota_empenho_despesa: 5678)

        # importante criar essa por último para garantir que todos os atributos
        # estão sendo considerados na associação.
        ned = create(:integration_expenses_ned, exercicio: 2010, unidade_gestora: 1234, numero: 5678)

        expect(ned.calculated_valor_pago_apos_exercicio).to eq(0.0)

        allow_any_instance_of(Integration::Expenses::Npd).to receive(:ned).and_return(ned)

        expect(ned).to receive(:child_updated).and_call_original

        npd.save

        expect(npd.reload.nld).to eq(nld)
        expect(nld.reload.ned).to eq(ned)

        ned.reload

        expect(ned.calculated_valor_pago_apos_exercicio).to eq(npd.valor)
      end
    end
  end
end
