require 'rails_helper'

describe Integration::Expenses::Npf do

  subject(:integration_expenses_npf) { build(:integration_expenses_npf) }

  let(:npf) { integration_expenses_npf }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_expenses_npf, :invalid)).to be_invalid }
  end

  it_behaves_like 'models/integration/expenses/base'

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:exercicio).of_type(:integer) }
      it { is_expected.to have_db_column(:unidade_gestora).of_type(:string) }
      it { is_expected.to have_db_column(:unidade_executora).of_type(:string) }
      it { is_expected.to have_db_column(:numero).of_type(:string) }
      it { is_expected.to have_db_column(:numero_npf_ord).of_type(:string) }
      it { is_expected.to have_db_column(:natureza).of_type(:string) }
      it { is_expected.to have_db_column(:tipo_proc_adm_desp).of_type(:string) }
      it { is_expected.to have_db_column(:efeito).of_type(:string) }
      it { is_expected.to have_db_column(:data_emissao).of_type(:string) }
      it { is_expected.to have_db_column(:grupo_fin).of_type(:string) }
      it { is_expected.to have_db_column(:fonte_rec).of_type(:string) }
      it { is_expected.to have_db_column(:numeroconvenio).of_type(:string) }
      it { is_expected.to have_db_column(:valor).of_type(:decimal) }
      it { is_expected.to have_db_column(:credor).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_projeto).of_type(:string) }
      it { is_expected.to have_db_column(:numero_parcela).of_type(:string) }
      it { is_expected.to have_db_column(:isn_parcela).of_type(:string) }
      it { is_expected.to have_db_column(:data_atual).of_type(:string) }

      it { is_expected.to have_db_column(:date_of_issue).of_type(:date) }

      # Calculated

      it { is_expected.to have_db_column(:calculated_valor_final).of_type(:decimal) }
      it { is_expected.to have_db_column(:calculated_valor_suplementado).of_type(:decimal) }
      it { is_expected.to have_db_column(:calculated_valor_anulado).of_type(:decimal) }

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

      # Índices de associações
      it { is_expected.to have_db_index(:numero_npf_ord) }
      it { is_expected.to have_db_index(:credor) }

      it { is_expected.to have_db_index([:exercicio, :unidade_gestora, :numero]) }
    end
  end

  describe 'associations' do

    it { is_expected.to belong_to(:management_unit).with_foreign_key(:unidade_gestora).with_primary_key(:codigo) }
    it { is_expected.to belong_to(:executing_unit).with_foreign_key(:unidade_executora).with_primary_key(:codigo) }
    it { is_expected.to belong_to(:creditor).with_foreign_key(:credor).with_primary_key(:codigo) }

    # Os testes mais robustos desses belong_to estão a seguir pois dependem de
    # chave composta (exercicio e unidade_gestora)
    it { is_expected.to belong_to(:npf_ordinaria) }

    it { is_expected.to have_one(:finance_group).with_foreign_key(:codigo_grupo_financeiro).with_primary_key(:grupo_fin) }
    it { is_expected.to have_one(:convenant).with_foreign_key(:isn_sic).with_primary_key(:numeroconvenio) }
    it { is_expected.to have_one(:resource_source).with_foreign_key(:codigo_fonte).with_primary_key(:fonte_rec) }

    #
    # Associação com NPF deve utilizar as colunas já existentes para evitar
    # finds no importador
    #
    it 'belongs_to npf_ordinaria' do
      npf.exercicio = 2010
      npf.unidade_gestora = 1234
      npf.numero_npf_ord = 5678

      # Esses registros não devem ser associados pois tem exercicio ou unidade_gestora distinta
      another_npf = create(:integration_expenses_npf, exercicio: 2011, unidade_gestora: 1234, numero_npf_ord: 5678)
      yet_another_npf = create(:integration_expenses_npf, exercicio: 2010, unidade_gestora: 9999, numero_npf_ord: 5678)

      # importante criar essa por último para garantir que todos os atributos
      # estão sendo considerados na associação.
      npf_ordinaria = create(:integration_expenses_npf, exercicio: 2010, unidade_gestora: 1234, numero: 5678)

      expect(npf.npf_ordinaria).to eq(npf_ordinaria)
    end

    #
    # Associação com NED deve utilizar as colunas já existentes para evitar
    # finds no importador
    #
    it 'has_many neds' do
      npf.exercicio = 2010
      npf.unidade_gestora = 1234
      npf.numero = 5678

      # Esses registros não devem ser associados pois tem exercicio ou unidade_gestora distinta
      another_ned = create(:integration_expenses_ned, exercicio: 2011, unidade_gestora: 1234, numero_npf_ordinario: 5678)
      yet_another_ned = create(:integration_expenses_ned, exercicio: 2010, unidade_gestora: 9999, numero_npf_ordinario: 5678)

      # importante criar essa por último para garantir que todos os atributos
      # estão sendo considerados na associação.
      ned = create(:integration_expenses_ned, exercicio: 2010, unidade_gestora: 1234, numero_npf_ordinario: 5678)
      second_ned = create(:integration_expenses_ned, exercicio: 2010, unidade_gestora: 1234, numero_npf_ordinario: 5678)

      expect(npf.neds).to match_array([ned, second_ned])
    end

    #
    # Associação com NPF deve utilizar as colunas já existentes para evitar
    # finds no importador
    #
    it 'has_many npfs' do
      npf.exercicio = 2010
      npf.unidade_gestora = 1234
      npf.numero = 5678

      # Esses registros não devem ser associados pois tem exercicio ou unidade_gestora distinta
      another_npf = create(:integration_expenses_npf, exercicio: 2011, unidade_gestora: 1234, numero_npf_ord: 5678)
      yet_another_npf = create(:integration_expenses_npf, exercicio: 2010, unidade_gestora: 9999, numero_npf_ord: 5678)

      # importante criar essa por último para garantir que todos os atributos
      # estão sendo considerados na associação.
      first_npf = create(:integration_expenses_npf, exercicio: 2010, unidade_gestora: 1234, numero_npf_ord: 5678)
      second_npf = create(:integration_expenses_npf, exercicio: 2010, unidade_gestora: 1234, numero_npf_ord: 5678)

      expect(npf.npfs).to match_array([first_npf, second_npf])
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:exercicio) }
    it { is_expected.to validate_presence_of(:unidade_gestora) }
    it { is_expected.to validate_presence_of(:numero) }
  end

  describe 'scopes' do
    it 'sorted' do
      first_unsorted = create(:integration_expenses_npf, data_emissao: '12/2010')
      last_unsorted = create(:integration_expenses_npf, data_emissao: '11/2010')
      expect(Integration::Expenses::Npf.sorted).to eq([first_unsorted, last_unsorted])
    end

    describe 'natureza' do
      let(:natureza_column_name) { "#{subject.class.table_name}.natureza" }

      it 'ordinarias' do
        expected = Integration::Expenses::Npf.where("#{natureza_column_name} = ? OR #{natureza_column_name} = ?", 'Ordinária', 'ORDINARIA')
        expect(Integration::Expenses::Npf.ordinarias).to eq(expected)
      end

      it 'suplementacoes' do
        expected = Integration::Expenses::Npf.where("#{natureza_column_name} = ? OR #{natureza_column_name} = ?", 'Suplementação', 'SUPLEMENTACAO')
        expect(Integration::Expenses::Npf.suplementacoes).to eq(expected)
      end

      it 'anulacoes' do
        expected = Integration::Expenses::Npf.where("#{natureza_column_name} = ? OR #{natureza_column_name} = ?", 'Anulação', 'ANULACAO')
        expect(Integration::Expenses::Npf.anulacoes).to eq(expected)
      end
    end
  end

  describe 'callbacks' do
    describe 'before_save' do
      it 'date_of_issue' do
        integration_expenses_npf.data_emissao = Date.today.to_s

        integration_expenses_npf.run_callbacks(:save)
        expect(integration_expenses_npf.date_of_issue).to eq(Date.today)
      end
    end

    describe 'after_commit' do
      describe 'calculated columns' do

        let(:base_data) do
          {
            unidade_gestora: '1',
            exercicio: '2010'
          }
        end

        it 'valor_suplementado e valor_anulado on parent npf'  do
          # A NED tem 3 tipos de natureza: 'ORDINARIA', 'ANULACAO' e 'SUPLEMENTACAO'.
          # Para 'ANULACAO' e 'SUPLEMENTACAO', temos a referência para a npf_ordinaria
          # e precisamos avisá-la que as colunas de calculated_valor_suplementado
          # e calculated_valor_anulado.

          parent_npf = create(:integration_expenses_npf, base_data.merge({natureza: 'ORDINARIA', valor: 1000}))

          suplementado_npf = create(:integration_expenses_npf, base_data.merge({natureza: 'SUPLEMENTACAO', npf_ordinaria: parent_npf, valor: 50}))
          another_suplementado_npf = create(:integration_expenses_npf, base_data.merge({natureza: 'SUPLEMENTACAO', npf_ordinaria: parent_npf, valor: 50}))

          anulado_npf = create(:integration_expenses_npf, base_data.merge({natureza: 'ANULACAO', npf_ordinaria: parent_npf, valor: 5}))
          another_anulado_npf = create(:integration_expenses_npf, base_data.merge({natureza: 'ANULACAO', npf_ordinaria: parent_npf, valor: 5}))


          # ORDINARIA:
          #  valor: 1000, valor_pago: 500
          #
          # Suplementado (total das 2 npfs)
          #  valor: 100, valor_pago: 50
          #
          # Anulado (total das 2 npfs)
          #  valor: 10, valor_pago: 4
          #
          # Final esprado:
          #
          # valor: 1000,
          # valor_pago: 500,
          # calculated_valor_final (valor + suplementado - anulado): 1090
          # calculated_valor_suplementado: 100
          # calculated_valor_anulado: 10
          #

          expect(suplementado_npf.npf_ordinaria).to eq(parent_npf)

          suplementado_npf.run_callbacks(:commit)

          parent_npf.reload

          expect(parent_npf.calculated_valor_suplementado).to eq(100)
          expect(parent_npf.calculated_valor_anulado).to eq(10)
          expect(parent_npf.calculated_valor_final).to eq(1090)
        end
      end
    end
  end
end
