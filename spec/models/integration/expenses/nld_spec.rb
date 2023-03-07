require 'rails_helper'

describe Integration::Expenses::Nld do

  subject(:integration_expenses_nld) { build(:integration_expenses_nld) }

  let(:nld) { integration_expenses_nld }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_expenses_nld, :invalid)).to be_invalid }
  end

  it_behaves_like 'models/integration/expenses/base'

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:exercicio).of_type(:integer) }
      it { is_expected.to have_db_column(:unidade_gestora).of_type(:string) }
      it { is_expected.to have_db_column(:unidade_executora).of_type(:string) }
      it { is_expected.to have_db_column(:numero).of_type(:string) }
      it { is_expected.to have_db_column(:numero_nld_ordinaria).of_type(:string) }
      it { is_expected.to have_db_column(:natureza).of_type(:string) }
      it { is_expected.to have_db_column(:tipo_de_documento_da_despesa).of_type(:string) }
      it { is_expected.to have_db_column(:numero_do_documento_da_despesa).of_type(:string) }
      it { is_expected.to have_db_column(:data_do_documento_da_despesa).of_type(:string) }
      it { is_expected.to have_db_column(:efeito).of_type(:string) }
      it { is_expected.to have_db_column(:processo_administrativo_despesa).of_type(:string) }
      it { is_expected.to have_db_column(:data_emissao).of_type(:string) }
      it { is_expected.to have_db_column(:valor).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_retido).of_type(:decimal) }
      it { is_expected.to have_db_column(:cpf_ordenador_despesa).of_type(:string) }
      it { is_expected.to have_db_column(:credor).of_type(:string) }
      it { is_expected.to have_db_column(:numero_npf_ordinaria).of_type(:string) }
      it { is_expected.to have_db_column(:numero_nld_ordinaria).of_type(:string) }
      it { is_expected.to have_db_column(:tipo_despesa_extra_orcamentaria).of_type(:string) }
      it { is_expected.to have_db_column(:especificacao_restituicao).of_type(:string) }
      it { is_expected.to have_db_column(:exercicio_restos_a_pagar).of_type(:string) }
      it { is_expected.to have_db_column(:data_atual).of_type(:string) }

      it { is_expected.to have_db_column(:date_of_issue).of_type(:date) }

      # Calculated

      it { is_expected.to have_db_column(:calculated_valor_final).of_type(:decimal) }
      it { is_expected.to have_db_column(:calculated_valor_anulado).of_type(:decimal) }

      # Colunas de chave composta para associações diretas de NED com NLD e NPD

      it { is_expected.to have_db_column(:composed_key).of_type(:string) }
      it { is_expected.to have_db_column(:ned_composed_key).of_type(:string) }

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

      # Índices de associações
      it { is_expected.to have_db_index(:numero_nld_ordinaria) }
      it { is_expected.to have_db_index(:numero_npf_ordinaria) }
      it { is_expected.to have_db_index(:numero_nota_empenho_despesa) }
      it { is_expected.to have_db_index(:numero_do_documento_da_despesa) }
      it { is_expected.to have_db_index(:credor) }

      it { is_expected.to have_db_index([:exercicio, :unidade_gestora, :numero]) }

      it { is_expected.to have_db_index(:composed_key) }
      it { is_expected.to have_db_index(:ned_composed_key) }
    end
  end

  describe 'associations' do

    it { is_expected.to belong_to(:management_unit).with_foreign_key(:unidade_gestora).with_primary_key(:codigo) }
    it { is_expected.to belong_to(:executing_unit).with_foreign_key(:unidade_executora).with_primary_key(:codigo) }
    it { is_expected.to belong_to(:creditor).with_foreign_key(:credor).with_primary_key(:codigo) }
    it { is_expected.to belong_to(:ned).with_foreign_key(:ned_composed_key).with_primary_key(:composed_key) }

    it { is_expected.to have_many(:nld_item_payment_retentions) }
    it { is_expected.to have_many(:nld_item_payment_plannings) }

    it { is_expected.to have_many(:npds).with_foreign_key(:nld_composed_key).with_primary_key(:composed_key) }

    #
    # Associação com NPF deve utilizar as colunas já existentes para evitar
    # finds no importador
    #
    it 'belongs_to ned' do
      nld.exercicio_restos_a_pagar = 2010
      nld.unidade_gestora = 1234
      nld.numero_nota_empenho_despesa = 5678

      # Esses registros não devem ser associados pois tem exercicio ou unidade_gestora distinta
      another_ned = create(:integration_expenses_ned, exercicio: 2011, unidade_gestora: 1234, numero: 5678)
      yet_another_ned = create(:integration_expenses_ned, exercicio: 2010, unidade_gestora: 9999, numero: 5678)

      # importante criar essa por último para garantir que todos os atributos
      # estão sendo considerados na associação.
      ned = create(:integration_expenses_ned, exercicio: 2010, unidade_gestora: 1234, numero: 5678)

      nld.save

      expect(nld.ned).to eq(ned)
    end

    #
    # Associação com NLD deve utilizar as colunas já existentes para evitar
    # finds no importador
    #
    it 'belongs_to nld_ordinaria' do
      nld.exercicio = 2010
      nld.unidade_gestora = 1234
      nld.numero_nld_ordinaria = 5678

      # Esses registros não devem ser associados pois tem exercicio ou unidade_gestora distinta
      another_nld = create(:integration_expenses_nld, exercicio: 2011, unidade_gestora: 1234, numero: 5678)
      yet_another_nld = create(:integration_expenses_nld, exercicio: 2010, unidade_gestora: 9999, numero: 5678)

      # importante criar essa por último para garantir que todos os atributos
      # estão sendo considerados na associação.
      nld_ordinaria = create(:integration_expenses_nld, exercicio: 2010, unidade_gestora: 1234, numero: 5678)

      expect(nld.nld_ordinaria).to eq(nld_ordinaria)
    end

    #
    # Associação com NPD deve utilizar as colunas já existentes para evitar
    # finds no importador
    #
    it 'has_many npds' do
      nld.exercicio = 2010
      nld.unidade_gestora = 1234
      nld.numero = 5678

      # Esses registros não devem ser associados pois tem exercicio ou unidade_gestora distinta
      another_npd = create(:integration_expenses_npd, exercicio: 2011, unidade_gestora: 1234, numero_nld_ordinaria: 5678)
      yet_another_npd = create(:integration_expenses_npd, exercicio: 2010, unidade_gestora: 9999, numero_nld_ordinaria: 5678)

      # importante criar essa por último para garantir que todos os atributos
      # estão sendo considerados na associação.
      npd = create(:integration_expenses_npd, exercicio: 2010, unidade_gestora: 1234, numero_nld_ordinaria: 5678)
      second_npd = create(:integration_expenses_npd, exercicio: 2010, unidade_gestora: 1234, numero_nld_ordinaria: 5678)

      nld.save

      expect(nld.npds).to match_array([npd, second_npd])
    end

    #
    # Associação com NLD deve utilizar as colunas já existentes para evitar
    # finds no importador
    #
    it 'has_many nlds' do
      nld.exercicio = 2010
      nld.unidade_gestora = 1234
      nld.numero = 5678

      # Esses registros não devem ser associados pois tem exercicio ou unidade_gestora distinta
      another_npd = create(:integration_expenses_npd, exercicio: 2011, unidade_gestora: 1234, numero_nld_ordinaria: 5678)
      yet_another_npd = create(:integration_expenses_npd, exercicio: 2010, unidade_gestora: 9999, numero_nld_ordinaria: 5678)

      # importante criar essa por último para garantir que todos os atributos
      # estão sendo considerados na associação.
      first_nld = create(:integration_expenses_nld, exercicio: 2010, unidade_gestora: 1234, numero_nld_ordinaria: 5678)
      second_nld = create(:integration_expenses_nld, exercicio: 2010, unidade_gestora: 1234, numero_nld_ordinaria: 5678)

      expect(nld.nlds).to match_array([first_nld, second_nld])
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:exercicio) }
    it { is_expected.to validate_presence_of(:unidade_gestora) }
    it { is_expected.to validate_presence_of(:numero) }
  end

  describe 'callbacks' do
    describe 'after_validation' do
      it 'sets composed_key' do
        expected = "#{nld.exercicio}#{nld.unidade_gestora}#{nld.numero}"
        nld.valid?

        expect(nld.composed_key).to eq(expected)
      end

      it 'sets ned_composed_key' do
        expected = "#{nld.exercicio_restos_a_pagar}#{nld.unidade_gestora}#{nld.numero_nota_empenho_despesa}"
        nld.valid?

        expect(nld.ned_composed_key).to eq(expected)
      end
    end

    describe 'after_commit' do
      describe 'calculated columns' do

        it 'calculated_valor_liquidado_exercicio on parent ned'  do
          # Precisamos atualizar os valores liquidados da NED

          nld.exercicio = 2010
          nld.exercicio_restos_a_pagar = 2010
          nld.unidade_gestora = 1234
          nld.numero_nota_empenho_despesa = 5678

          # importante criar essa por último para garantir que todos os atributos
          # estão sendo considerados na associação.
          ned = create(:integration_expenses_ned, exercicio: 2010, unidade_gestora: 1234, numero: 5678)

          expect(ned.calculated_valor_liquidado_apos_exercicio).to eq(0.0)

          allow_any_instance_of(Integration::Expenses::Nld).to receive(:ned).and_return(ned)

          expect(ned).to receive(:child_updated).and_call_original

          nld.save

          expect(ned.calculated_valor_liquidado_exercicio).to eq(nld.valor)
        end

        it 'calculated_valor_liquidado_apos_exercicio on parent ned'  do
          # Precisamos atualizar os valores liquidados da NED

          nld.exercicio_restos_a_pagar = 2010
          nld.unidade_gestora = 1234
          nld.numero_nota_empenho_despesa = 5678

          # importante criar essa por último para garantir que todos os atributos
          # estão sendo considerados na associação.
          ned = create(:integration_expenses_ned, exercicio: 2010, unidade_gestora: 1234, numero: 5678)

          expect(ned.calculated_valor_liquidado_apos_exercicio).to eq(0.0)

          allow_any_instance_of(Integration::Expenses::Nld).to receive(:ned).and_return(ned)

          expect(ned).to receive(:child_updated).and_call_original

          nld.save

          expect(ned.calculated_valor_liquidado_apos_exercicio).to eq(nld.valor)
        end
      end
    end
  end

  describe 'scopes' do
    it 'sorted' do
      first_unsorted = create(:integration_expenses_nld, data_emissao: '12/2010')
      last_unsorted = create(:integration_expenses_nld, data_emissao: '11/2010')
      expect(Integration::Expenses::Nld.sorted).to eq([first_unsorted, last_unsorted])
    end

    describe 'natureza' do
      let(:natureza_column_name) { "#{subject.class.table_name}.natureza" }

      it 'ordinarias' do
        expected = Integration::Expenses::Nld.where("#{natureza_column_name} = ? OR #{natureza_column_name} = ?", 'Ordinária', 'ORDINARIA')
        expect(Integration::Expenses::Nld.ordinarias).to eq(expected)
      end

      it 'suplementacoes' do
        expected = Integration::Expenses::Nld.where("#{natureza_column_name} = ? OR #{natureza_column_name} = ?", 'Suplementação', 'SUPLEMENTACAO')
        expect(Integration::Expenses::Nld.suplementacoes).to eq(expected)
      end

      it 'anulacoes' do
        expected = Integration::Expenses::Nld.where("#{natureza_column_name} = ? OR #{natureza_column_name} = ?", 'Anulação', 'ANULACAO')
        expect(Integration::Expenses::Nld.anulacoes).to eq(expected)
      end
    end
  end
end
