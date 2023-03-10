require 'rails_helper'

describe Integration::Expenses::BudgetBalance do

  subject(:integration_expenses_budget_balance) { build(:integration_expenses_budget_balance) }

  let(:budget_balance) { integration_expenses_budget_balance }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_expenses_budget_balance, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:data_atual).of_type(:string) }
      it { is_expected.to have_db_column(:ano_mes_competencia).of_type(:string) }
      it { is_expected.to have_db_column(:cod_unid_gestora).of_type(:string) }
      it { is_expected.to have_db_column(:cod_unid_orcam).of_type(:string) }
      it { is_expected.to have_db_column(:cod_funcao).of_type(:string) }
      it { is_expected.to have_db_column(:cod_subfuncao).of_type(:string) }
      it { is_expected.to have_db_column(:cod_programa).of_type(:string) }
      it { is_expected.to have_db_column(:cod_acao).of_type(:string) }
      it { is_expected.to have_db_column(:cod_localizacao_gasto).of_type(:string) }
      it { is_expected.to have_db_column(:cod_natureza_desp).of_type(:string) }
      it { is_expected.to have_db_column(:cod_fonte).of_type(:string) }
      it { is_expected.to have_db_column(:id_uso).of_type(:string) }
      it { is_expected.to have_db_column(:cod_grupo_desp).of_type(:string) }
      it { is_expected.to have_db_column(:cod_tp_orcam).of_type(:string) }
      it { is_expected.to have_db_column(:cod_esfera_orcam).of_type(:string) }
      it { is_expected.to have_db_column(:cod_grupo_fin).of_type(:string) }
      it { is_expected.to have_db_column(:cod_categoria_economica).of_type(:string) }
      it { is_expected.to have_db_column(:cod_modalidade_aplicacao).of_type(:string) }
      it { is_expected.to have_db_column(:cod_elemento_despesa).of_type(:string) }
      it { is_expected.to have_db_column(:classif_orcam_reduz).of_type(:string) }
      it { is_expected.to have_db_column(:classif_orcam_completa).of_type(:string) }

      it { is_expected.to have_db_column(:valor_inicial).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_suplementado).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_anulado).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_transferido_recebido).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_transferido_concedido).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_contido).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_contido_anulado).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_descentralizado).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_descentralizado_anulado).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_empenhado).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_empenhado_anulado).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_liquidado).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_liquidado_anulado).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_liquidado_retido).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_liquidado_retido_anulado).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_pago).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_pago_anulado).of_type(:decimal) }

      # Rela????o com Secretaria/??rg??o ?? feita separado por conta da data de t??rmino
      # dos ??rg??os. Ou seja, n??o basta associar por 'cod_unid_gestora'.

      it { is_expected.to have_db_column(:integration_supports_organ_id).of_type(:integer) }
      it { is_expected.to have_db_column(:integration_supports_secretary_id).of_type(:integer) }
      it { is_expected.to have_db_column(:integration_supports_government_program_id).of_type(:integer) }


      # Calculated

      it { is_expected.to have_db_column(:calculated_valor_orcamento_inicial).of_type(:decimal) }
      it { is_expected.to have_db_column(:calculated_valor_orcamento_atualizado).of_type(:decimal) }
      it { is_expected.to have_db_column(:calculated_valor_empenhado).of_type(:decimal) }
      it { is_expected.to have_db_column(:calculated_valor_liquidado).of_type(:decimal) }
      it { is_expected.to have_db_column(:calculated_valor_pago).of_type(:decimal) }

      it { is_expected.to have_db_column(:month).of_type(:integer) }
      it { is_expected.to have_db_column(:year).of_type(:integer) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:ano_mes_competencia) }
      it { is_expected.to have_db_index(:cod_unid_gestora) }
      it { is_expected.to have_db_index(:cod_unid_orcam) }
      it { is_expected.to have_db_index(:cod_funcao) }
      it { is_expected.to have_db_index(:cod_subfuncao) }
      it { is_expected.to have_db_index(:cod_programa) }
      it { is_expected.to have_db_index(:cod_acao) }
      it { is_expected.to have_db_index(:cod_localizacao_gasto) }
      it { is_expected.to have_db_index(:cod_natureza_desp) }
      it { is_expected.to have_db_index(:cod_fonte) }
      it { is_expected.to have_db_index(:id_uso) }
      it { is_expected.to have_db_index(:cod_grupo_desp) }
      it { is_expected.to have_db_index(:cod_tp_orcam) }
      it { is_expected.to have_db_index(:cod_esfera_orcam) }
      it { is_expected.to have_db_index(:cod_grupo_fin) }
      it { is_expected.to have_db_index(:classif_orcam_completa) }
      it { is_expected.to have_db_index(:month) }
      it { is_expected.to have_db_index(:year) }

      it { is_expected.to have_db_index(:cod_categoria_economica) }
      it { is_expected.to have_db_index(:cod_modalidade_aplicacao) }
      it { is_expected.to have_db_index(:cod_elemento_despesa) }

      it { is_expected.to have_db_index(:integration_supports_organ_id) }
      it { is_expected.to have_db_index(:integration_supports_secretary_id) }
      it { is_expected.to have_db_index(:integration_supports_government_program_id) }
    end
  end

  describe 'associations' do
    #
    # Associa????es relacionadas ?? classifica????o or??ament??ria
    #
    describe 'classification associations' do
      it { is_expected.to belong_to(:management_unit).with_foreign_key(:cod_unid_gestora).with_primary_key(:codigo) }
      it { is_expected.to belong_to(:budget_unit).with_foreign_key(:cod_unid_orcam).with_primary_key(:codigo_unidade_orcamentaria) }
      it { is_expected.to belong_to(:function).with_foreign_key(:cod_funcao).with_primary_key(:codigo_funcao) }
      it { is_expected.to belong_to(:sub_function).with_foreign_key(:cod_subfuncao).with_primary_key(:codigo_sub_funcao) }
      it { is_expected.to belong_to(:government_program).with_foreign_key(:integration_supports_government_program_id) }
      it { is_expected.to belong_to(:government_action).with_foreign_key(:cod_acao).with_primary_key(:codigo_acao) }
      it { is_expected.to belong_to(:administrative_region).with_foreign_key(:cod_localizacao_gasto).with_primary_key(:codigo_regiao_resumido) }
      it { is_expected.to belong_to(:expense_nature).with_foreign_key(:cod_natureza_desp).with_primary_key(:codigo_natureza_despesa) }
      it { is_expected.to belong_to(:qualified_resource_source).with_foreign_key(:cod_fonte).with_primary_key(:codigo) }
      it { is_expected.to belong_to(:finance_group).with_foreign_key(:cod_grupo_fin).with_primary_key(:codigo_grupo_financeiro) }

      it { is_expected.to belong_to(:economic_category).with_foreign_key(:cod_categoria_economica).with_primary_key(:codigo_categoria_economica) }
      it { is_expected.to belong_to(:application_modality).with_foreign_key(:cod_modalidade_aplicacao).with_primary_key(:codigo_modalidade) }
      it { is_expected.to belong_to(:expense_element).with_foreign_key(:cod_elemento_despesa).with_primary_key(:codigo_elemento_despesa) }
    end

    context 'existing foreign_keys' do
      it 'organ and secretary'  do

        secretary = create(:integration_supports_organ, :secretary, orgao_sfp: false)
        #
        # O organ deve ser relacionar com a tabela integration_supports_organs.codigo_orgao (orgao_sfp: false)
        # usando sua coluna cod_unid_gestora.
        #
        organ = create(:integration_supports_organ, codigo_orgao: '1234', codigo_entidade: secretary.codigo_entidade, orgao_sfp: false)

        # a flag orgao_sfp ?? usada para definir ??rg??os da folha de pagamento. H?? sempre 2 ??rg??os
        # iguais (um com sfp true e outro false),
        organ_sfp = create(:integration_supports_organ, codigo_orgao: '1234', orgao_sfp: true)

        revenue = create(:integration_expenses_budget_balance, cod_unid_gestora: '1234')

        expect(revenue.organ).to eq(organ)
        expect(revenue.secretary).to eq(secretary)
      end

      it 'organ with data_termino'  do
        # Devemos considerar o ??rg??o de acordo com a data de t??rmino
        # Ex:
        # SECRETARIA DA SEGURAN??A P??BLICA E DEFESA SOCIAL: data_termino: 06/12/2017
        # Como a receita s?? tem m??s/ano, vamos considerar a data_termino do ??rg??o como sendo o final do m??s.

        organ = create(:integration_supports_organ, codigo_orgao: '1234', orgao_sfp: false, data_termino: nil)
        revenue = create(:integration_expenses_budget_balance, cod_unid_gestora: '1234')

        expect(revenue.organ).to eq(organ)

        data_termino = Date.new(revenue.year, revenue.month, 01).end_of_month
        organ_data_termino = create(:integration_supports_organ, codigo_orgao: '1234', orgao_sfp: false, data_termino: data_termino)

        revenue.valid?
        revenue.save

        expect(revenue.reload.organ).to eq(organ_data_termino)
      end

      it 'government_program with ano_inicio'  do
        # H?? v??rias repeti????es de GovernmentProgram com mesmos c??digos e t??tulos,
        # mas com anos de in??cio diferentes.
        #
        # Temos que encontrar o mais pr??ximo deste registro e associar especificamente
        # para n??o haver repeti????es no JOIN

        base_year = 2017
        budget_balance.cod_programa = '1234'

        first_program = create(:integration_supports_government_program, codigo_programa: '1234', ano_inicio: base_year)
        second_program = create(:integration_supports_government_program, codigo_programa: '1234', ano_inicio: base_year + 1)

        budget_balance.year = base_year
        budget_balance.valid?
        expect(budget_balance.government_program).to eq(first_program)

        # N??o existia programa no ano anteior
        budget_balance.year = base_year - 1
        budget_balance.valid?
        expect(budget_balance.government_program).to eq(nil)

        budget_balance.year = base_year + 1
        budget_balance.valid?
        expect(budget_balance.government_program).to eq(second_program)

        # Pega o ??ltimo programa!
        budget_balance.year = base_year + 3
        budget_balance.valid?
        expect(budget_balance.government_program).to eq(second_program)
      end
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:ano_mes_competencia) }
    it { is_expected.to validate_presence_of(:cod_unid_gestora) }
    it { is_expected.to validate_presence_of(:cod_unid_orcam) }
  end


  describe 'delegations' do
    it { is_expected.to delegate_method(:title).to(:secretary).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:organ).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:function).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:sub_function).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:government_program).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:government_action).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:administrative_region).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:expense_nature).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:qualified_resource_source).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:finance_group).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:economic_category).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:application_modality).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:expense_element).with_arguments(allow_nil: true).with_prefix }
  end

  describe 'callbacks' do
    it 'calculated_valor_orcamento_inicial' do
      budget_balance.valor_inicial = 123
      budget_balance.calculated_valor_orcamento_inicial = nil
      budget_balance.valid?

      expected = 123

      expect(budget_balance.calculated_valor_orcamento_inicial).to eq(expected)
    end

    it 'calculated_valor_orcamento_atualizado' do
      budget_balance.valor_inicial = 123
      budget_balance.valor_suplementado = 100
      budget_balance.valor_anulado = 23
      budget_balance.valor_transferido_recebido = 10
      budget_balance.valor_transferido_concedido = 10
      budget_balance.valid?

      expected = 200

      expect(budget_balance.calculated_valor_orcamento_atualizado).to eq(expected)
    end

    it 'calculated_valor_empenhado' do
      budget_balance.valor_empenhado = 123
      budget_balance.valor_empenhado_anulado = 100
      budget_balance.valid?

      expected = 23

      expect(budget_balance.calculated_valor_empenhado).to eq(expected)
    end

    it 'calculated_valor_liquidado' do
      budget_balance.valor_liquidado = 123
      budget_balance.valor_liquidado_anulado = 100
      budget_balance.valid?

      expected = 23

      expect(budget_balance.calculated_valor_liquidado).to eq(expected)
    end

    it 'calculated_valor_pago' do
      budget_balance.valor_pago = 123
      budget_balance.valor_pago_anulado = 100

      budget_balance.valor_liquidado_retido = 12
      budget_balance.valor_liquidado_retido_anulado = 24

      budget_balance.valid?

      expected = (123 - 100) + (12 - 24)

      expect(budget_balance.calculated_valor_pago).to eq(expected)
    end

    it 'month and year' do
      budget_balance.ano_mes_competencia = '09-2017'
      budget_balance.month = nil
      budget_balance.year = nil
      budget_balance.valid?

      expect(budget_balance.year).to eq(2017)
      expect(budget_balance.month).to eq(9)
    end

    it 'codigos' do
      # - campo cod_natureza_desp:
      #   categoria econ??mica: posi????o 1
      #   modalidade de aplica????o: posi????o 3 e 4
      #   elemento de despesa: posi????o 5 e 6

      budget_balance.cod_natureza_desp = '123456789'
      budget_balance.valid?

      expect(budget_balance.cod_categoria_economica).to eq('1')
      expect(budget_balance.cod_modalidade_aplicacao).to eq('34')
      expect(budget_balance.cod_elemento_despesa).to eq('56')
    end
  end
end
