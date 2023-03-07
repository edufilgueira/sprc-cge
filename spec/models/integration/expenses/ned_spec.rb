require 'rails_helper'

describe Integration::Expenses::Ned do

  subject(:integration_expenses_ned) { build(:integration_expenses_ned) }

  let(:ned) { integration_expenses_ned }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_expenses_ned, :invalid)).to be_invalid }
  end

  it_behaves_like 'models/integration/expenses/base'

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:exercicio).of_type(:integer) }
      it { is_expected.to have_db_column(:unidade_gestora).of_type(:string) }
      it { is_expected.to have_db_column(:unidade_executora).of_type(:string) }
      it { is_expected.to have_db_column(:numero).of_type(:string) }
      it { is_expected.to have_db_column(:numero_ned_ordinaria).of_type(:string) }
      it { is_expected.to have_db_column(:natureza).of_type(:string) }
      it { is_expected.to have_db_column(:efeito).of_type(:string) }
      it { is_expected.to have_db_column(:data_emissao).of_type(:string) }
      it { is_expected.to have_db_column(:valor).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_pago).of_type(:decimal) }
      it { is_expected.to have_db_column(:classificacao_orcamentaria_reduzido).of_type(:integer) }
      it { is_expected.to have_db_column(:classificacao_orcamentaria_completo).of_type(:string) }
      it { is_expected.to have_db_column(:item_despesa).of_type(:string) }
      it { is_expected.to have_db_column(:cpf_ordenador_despesa).of_type(:string) }
      it { is_expected.to have_db_column(:credor).of_type(:string) }
      it { is_expected.to have_db_column(:cpf_cnpj_credor).of_type(:string) }
      it { is_expected.to have_db_column(:razao_social_credor).of_type(:string) }
      it { is_expected.to have_db_column(:numero_npf_ordinario).of_type(:string) }
      it { is_expected.to have_db_column(:projeto).of_type(:string) }
      it { is_expected.to have_db_column(:numero_parcela).of_type(:string) }
      it { is_expected.to have_db_column(:isn_parcela).of_type(:integer) }
      it { is_expected.to have_db_column(:numero_contrato).of_type(:string) }
      it { is_expected.to have_db_column(:numero_convenio).of_type(:string) }
      it { is_expected.to have_db_column(:modalidade_sem_licitacao).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_dispositivo_legal).of_type(:string) }
      it { is_expected.to have_db_column(:modalidade_licitacao).of_type(:string) }
      it { is_expected.to have_db_column(:tipo_proposta).of_type(:integer) }
      it { is_expected.to have_db_column(:numero_proposta).of_type(:integer) }
      it { is_expected.to have_db_column(:numero_proposta_origem).of_type(:integer) }
      it { is_expected.to have_db_column(:numero_processo_protocolo_original).of_type(:string) }
      it { is_expected.to have_db_column(:especificacao_geral).of_type(:string) }
      it { is_expected.to have_db_column(:data_atual).of_type(:string) }

      it { is_expected.to have_db_column(:date_of_issue).of_type(:date) }

      it { is_expected.to have_db_column(:transfer_type).of_type(:integer) }

      # Calculated

      it { is_expected.to have_db_column(:calculated_valor_final).of_type(:decimal) }
      it { is_expected.to have_db_column(:calculated_valor_pago_final).of_type(:decimal) }
      it { is_expected.to have_db_column(:calculated_valor_suplementado).of_type(:decimal) }
      it { is_expected.to have_db_column(:calculated_valor_pago_suplementado).of_type(:decimal) }
      it { is_expected.to have_db_column(:calculated_valor_anulado).of_type(:decimal) }
      it { is_expected.to have_db_column(:calculated_valor_pago_anulado).of_type(:decimal) }


      it { is_expected.to have_db_column(:calculated_valor_liquidado_exercicio).of_type(:decimal) }
      it { is_expected.to have_db_column(:calculated_valor_liquidado_apos_exercicio).of_type(:decimal) }
      it { is_expected.to have_db_column(:calculated_valor_pago_exercicio).of_type(:decimal) }
      it { is_expected.to have_db_column(:calculated_valor_pago_apos_exercicio).of_type(:decimal) }

      # Colunas derivadas da classificação orçamentária completa

      it { is_expected.to have_db_column(:classificacao_unidade_orcamentaria).of_type(:string) }
      it { is_expected.to have_db_column(:classificacao_funcao).of_type(:string) }
      it { is_expected.to have_db_column(:classificacao_subfuncao).of_type(:string) }
      it { is_expected.to have_db_column(:classificacao_programa_governo).of_type(:string) }
      it { is_expected.to have_db_column(:classificacao_acao_governamental).of_type(:string) }
      it { is_expected.to have_db_column(:classificacao_regiao_administrativa).of_type(:string) }
      it { is_expected.to have_db_column(:classificacao_natureza_despesa).of_type(:string) }
      it { is_expected.to have_db_column(:classificacao_cod_destinacao).of_type(:string) }
      it { is_expected.to have_db_column(:classificacao_fonte_recursos).of_type(:string) }
      it { is_expected.to have_db_column(:classificacao_subfonte).of_type(:string) }
      it { is_expected.to have_db_column(:classificacao_id_uso).of_type(:string) }
      it { is_expected.to have_db_column(:classificacao_tipo_despesa).of_type(:string) }
      it { is_expected.to have_db_column(:classificacao_elemento_despesa).of_type(:string) }

      # Colunas de chave composta para associações diretas com NLD e NPD

      it { is_expected.to have_db_column(:composed_key).of_type(:string) }

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
      it { is_expected.to have_db_index(:transfer_type) }

      # Índices de associações
      it { is_expected.to have_db_index(:numero_ned_ordinaria) }
      it { is_expected.to have_db_index(:numero_npf_ordinario) }
      it { is_expected.to have_db_index(:credor) }
      it { is_expected.to have_db_index(:projeto) }
      it { is_expected.to have_db_index(:numero_contrato) }
      it { is_expected.to have_db_index(:numero_convenio) }

      it { is_expected.to have_db_index(:classificacao_unidade_orcamentaria) }
      it { is_expected.to have_db_index(:classificacao_funcao) }
      it { is_expected.to have_db_index(:classificacao_subfuncao) }
      it { is_expected.to have_db_index(:classificacao_programa_governo) }
      it { is_expected.to have_db_index(:classificacao_acao_governamental) }
      it { is_expected.to have_db_index(:classificacao_regiao_administrativa) }
      it { is_expected.to have_db_index(:classificacao_natureza_despesa) }
      it { is_expected.to have_db_index(:classificacao_cod_destinacao) }
      it { is_expected.to have_db_index(:classificacao_fonte_recursos) }
      it { is_expected.to have_db_index(:classificacao_subfonte) }
      it { is_expected.to have_db_index(:classificacao_id_uso) }
      it { is_expected.to have_db_index(:classificacao_tipo_despesa) }
      it { is_expected.to have_db_index(:classificacao_elemento_despesa) }

      it { is_expected.to have_db_index(:composed_key) }
    end
  end

  describe 'associations' do

    # Os testes mais robustos desses belong_to estão a seguir pois dependem de
    # chave composta (exercicio e unidade_gestora)
    it { is_expected.to belong_to(:ned_ordinaria) }
    it { is_expected.to belong_to(:npf_ordinaria) }


    it { is_expected.to belong_to(:management_unit).with_foreign_key(:unidade_gestora).with_primary_key(:codigo) }
    it { is_expected.to belong_to(:executing_unit).with_foreign_key(:unidade_executora).with_primary_key(:codigo) }
    it { is_expected.to belong_to(:creditor).with_foreign_key(:credor).with_primary_key(:codigo) }

    it { is_expected.to have_many(:ned_items) }
    it { is_expected.to have_many(:ned_planning_items) }
    it { is_expected.to have_many(:ned_disbursement_forecasts) }

    it { is_expected.to have_many(:nlds).with_foreign_key(:ned_composed_key).with_primary_key(:composed_key) }

    it { is_expected.to have_many(:npds).through(:nlds) }

    it { is_expected.to belong_to(:expense_nature_item).with_foreign_key(:item_despesa).with_primary_key(:codigo_item_natureza) }
    it { is_expected.to have_one(:convenant).with_foreign_key(:isn_sic).with_primary_key(:numero_convenio) }
    it { is_expected.to have_one(:contract).with_foreign_key(:isn_sic).with_primary_key(:numero_contrato) }
    it { is_expected.to have_one(:legal_device).with_foreign_key(:codigo).with_primary_key(:codigo_dispositivo_legal) }

    #
    # Associação com NPF deve utilizar as colunas já existentes para evitar
    # finds no importador
    #
    it 'belongs_to npf_ordinaria' do
      ned.exercicio = 2010
      ned.unidade_gestora = 1234
      ned.numero_npf_ordinario = 5678

      # Esses registros não devem ser associados pois tem exercicio ou unidade_gestora distinta
      another_npf = create(:integration_expenses_npf, exercicio: 2011, unidade_gestora: 1234, numero: 5678)
      yet_another_npf = create(:integration_expenses_npf, exercicio: 2010, unidade_gestora: 9999, numero: 5678)

      # importante criar essa por último para garantir que todos os atributos
      # estão sendo considerados na associação.
      npf_ordinaria = create(:integration_expenses_npf, exercicio: 2010, unidade_gestora: 1234, numero: 5678)

      expect(ned.npf_ordinaria).to eq(npf_ordinaria)
    end

    #
    # Associação com NED deve utilizar as colunas já existentes para evitar
    # finds no importador
    #
    it 'belongs_to ned_ordinaria' do
      ned.exercicio = 2010
      ned.unidade_gestora = 1234
      ned.numero_ned_ordinaria = 5678

      # Esses registros não devem ser associados pois tem exercicio ou unidade_gestora distinta
      another_ned = create(:integration_expenses_ned, exercicio: 2011, unidade_gestora: 1234, numero: 5678)
      yet_another_ned = create(:integration_expenses_ned, exercicio: 2010, unidade_gestora: 9999, numero: 5678)

      # importante criar essa por último para garantir que todos os atributos
      # estão sendo considerados na associação.
      ned_ordinaria = create(:integration_expenses_ned, exercicio: 2010, unidade_gestora: 1234, numero: 5678)

      expect(ned.ned_ordinaria).to eq(ned_ordinaria)
    end

    #
    # Associação com NLD deve utilizar as colunas já existentes para evitar
    # finds no importador
    #
    it 'has_many nlds' do
      ned.exercicio = 2010
      ned.unidade_gestora = 1234
      ned.numero = 5678

      # Esses registros não devem ser associados pois tem exercicio ou unidade_gestora distinta
      another_nld = create(:integration_expenses_nld, exercicio_restos_a_pagar: 2011, unidade_gestora: 1234, numero_nota_empenho_despesa: 5678)
      yet_another_nld = create(:integration_expenses_nld, exercicio_restos_a_pagar: 2010, unidade_gestora: 9999, numero_nota_empenho_despesa: 5678)

      # importante criar essa por último para garantir que todos os atributos
      # estão sendo considerados na associação.
      nld = create(:integration_expenses_nld, exercicio_restos_a_pagar: 2010, unidade_gestora: 1234, numero_nota_empenho_despesa: 5678)
      second_nld = create(:integration_expenses_nld, exercicio_restos_a_pagar: 2010, unidade_gestora: 1234, numero_nota_empenho_despesa: 5678)

      ned.save

      expect(ned.nlds).to match_array([nld, second_nld])
    end

    it 'nlds and npds from another years' do
      ned = create(:integration_expenses_ned, exercicio: 2011, unidade_gestora: 1234, numero: 5678)
      nld = create(:integration_expenses_nld, exercicio: 2012, exercicio_restos_a_pagar: 2011, unidade_gestora: 1234, numero_nota_empenho_despesa: 5678, numero: 1234)
      npd = create(:integration_expenses_npd, exercicio: 2012, unidade_gestora: 1234, numero_nld_ordinaria: 1234)

      ignored_npd = create(:integration_expenses_npd, exercicio: 2011, unidade_gestora: 1234, numero_nld_ordinaria: 1234)

      expect(nld.ned).to eq(ned)
      expect(ned.nlds.reload).to eq([nld])
      expect(nld.npds).to eq([npd])

      expect(ned.npds).to eq([npd])
    end

    #
    # Associação com NED deve utilizar as colunas já existentes para evitar
    # finds no importador
    #
    it 'has_many neds' do
      ned.exercicio = 2010
      ned.unidade_gestora = 1234
      ned.numero = 5678

      # Esses registros não devem ser associados pois tem exercicio ou unidade_gestora distinta
      another_ned = create(:integration_expenses_ned, exercicio: 2011, unidade_gestora: 1234, numero_ned_ordinaria: 5678)
      yet_another_ned = create(:integration_expenses_ned, exercicio: 2010, unidade_gestora: 9999, numero_ned_ordinaria: 5678)

      # importante criar essa por último para garantir que todos os atributos
      # estão sendo considerados na associação.
      first_ned = create(:integration_expenses_ned, exercicio: 2010, unidade_gestora: 1234, numero_ned_ordinaria: 5678)
      second_ned = create(:integration_expenses_ned, exercicio: 2010, unidade_gestora: 1234, numero_ned_ordinaria: 5678)

      expect(ned.neds).to match_array([first_ned, second_ned])
    end

    it 'has_one government_program' do
      ned = create(:integration_expenses_ned, exercicio: 2018)
      codigo = ned.classificacao_programa_governo

      gp_2011 = create(:integration_supports_government_program, ano_inicio: '2011', codigo_programa: codigo)
      gp_2017 = create(:integration_supports_government_program, ano_inicio: '2017', codigo_programa: codigo)

      expect(ned.government_program).to eq(gp_2017)
    end

    #
    # Associações relacionadas à classificação orçamentária
    #
    describe 'classification associations' do
      it { is_expected.to have_one(:budget_unit).with_foreign_key(:codigo_unidade_orcamentaria).with_primary_key(:classificacao_unidade_orcamentaria) }
      it { is_expected.to have_one(:function).with_foreign_key(:codigo_funcao).with_primary_key(:classificacao_funcao) }
      it { is_expected.to have_one(:sub_function).with_foreign_key(:codigo_sub_funcao).with_primary_key(:classificacao_subfuncao) }
      it { is_expected.to have_one(:government_action).with_foreign_key(:codigo_acao).with_primary_key(:classificacao_acao_governamental) }
      it { is_expected.to have_one(:administrative_region).with_foreign_key(:codigo_regiao_resumido).with_primary_key(:classificacao_regiao_administrativa) }
      it { is_expected.to have_one(:expense_nature).with_foreign_key(:codigo_natureza_despesa).with_primary_key(:classificacao_natureza_despesa) }
      it { is_expected.to have_one(:resource_source).with_foreign_key(:codigo_fonte).with_primary_key(:classificacao_fonte_recursos) }
      it { is_expected.to have_one(:expense_type).with_foreign_key(:codigo).with_primary_key(:classificacao_tipo_despesa) }
      it { is_expected.to belong_to(:expense_element).with_primary_key(:codigo_elemento_despesa).with_foreign_key(:classificacao_elemento_despesa) }
    end
  end

  describe 'enums' do
    it 'transfer_type' do
      # Campo item_despesa:

      # a. Transferência a município -  nas posições 3 e 4, onde o valor estejam preenchidos com '40' ou '41'.
      # b. Transferência a entidade sem fins lucrativos - nas posições 3 e 4, onde o valor estejam preenchidos com '50'
      # c. Transferência a entidades com fins lucrativos - nas posições 3 e 4, onde o valor estejam preenchidos com '60'
      # d. Transferências a Instituições Multigovernamentais- nas posições 3 e 4, onde o valor estejam preenchidos com '70'
      # e. Transferências a Consórcios Públicos - nas posições 3 e 4, onde o valor estejam preenchidos com '71'

      transfers = [
        :transfer_none,
        :transfer_cities,
        :transfer_non_profits,
        :transfer_profits,
        :transfer_multi_govs,
        :transfer_consortiums
      ]

      is_expected.to define_enum_for(:transfer_type).with_values(transfers)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:exercicio) }
    it { is_expected.to validate_presence_of(:unidade_gestora) }
    it { is_expected.to validate_presence_of(:numero) }

    it { is_expected.to validate_presence_of(:numero_npf_ordinario) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:title).to(:management_unit).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:acronym).to(:management_unit).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:executing_unit).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:acronym).to(:executing_unit).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:nome).to(:creditor).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:expense_nature_item).with_arguments(allow_nil: true).with_prefix }

    it { is_expected.to delegate_method(:title).to(:function).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:sub_function).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:government_program).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:government_action).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:administrative_region).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:expense_nature).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:resource_source).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:expense_type).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:expense_nature_item).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:expense_element).with_arguments(allow_nil: true).with_prefix }
  end

  describe 'scopes' do
    it 'sorted' do
      first_unsorted = create(:integration_expenses_ned, data_emissao: '12/2010')
      last_unsorted = create(:integration_expenses_ned, data_emissao: '11/2010')
      expect(Integration::Expenses::Ned.sorted).to eq([first_unsorted, last_unsorted])
    end

    it 'from_year' do
      filtered = create(:integration_expenses_ned, exercicio: '2017')
      non_filtered = create(:integration_expenses_ned, exercicio: '2018')

      expect(Integration::Expenses::Ned.from_year(2017)).to eq([filtered])
    end

    describe 'natureza' do
      let(:natureza_column_name) { "#{subject.class.table_name}.natureza" }

      it 'ordinarias' do
        expected = Integration::Expenses::Ned.where("#{natureza_column_name} = ? OR #{natureza_column_name} = ?", 'Ordinária', 'ORDINARIA')
        expect(Integration::Expenses::Ned.ordinarias).to eq(expected)
      end

      it 'suplementacoes' do
        expected = Integration::Expenses::Ned.where("#{natureza_column_name} = ? OR #{natureza_column_name} = ?", 'Suplementação', 'SUPLEMENTACAO')
        expect(Integration::Expenses::Ned.suplementacoes).to eq(expected)
      end

      it 'anulacoes' do
        expected = Integration::Expenses::Ned.where("#{natureza_column_name} = ? OR #{natureza_column_name} = ?", 'Anulação', 'ANULACAO')
        expect(Integration::Expenses::Ned.anulacoes).to eq(expected)
      end
    end
  end

  describe 'helpers' do
    it 'title' do
      expect(integration_expenses_ned.title).to eq("#{integration_expenses_ned.management_unit_acronym} - #{integration_expenses_ned.numero}/#{integration_expenses_ned.exercicio}")
    end

    it 'items_description' do
      expect(integration_expenses_ned.items_description).to eq('')

      ned.save
      create(:integration_expenses_ned_item, ned: ned, especificacao: '123')
      create(:integration_expenses_ned_item, ned: ned, especificacao: '456')

      expected = ned.ned_items.pluck(:especificacao).join(' / ')

      expect(integration_expenses_ned.items_description).to eq(expected)
    end

    it 'daily?' do

      ned.classificacao_orcamentaria_completo = "10100002061220032238703339014001000003000"
      ned.exercicio = 2017
      expect(ned).to be_daily
    end
  end

  describe 'callbacks' do
    describe 'before_save' do
      it 'date_of_issue' do
        integration_expenses_ned.data_emissao = Date.today.to_s
        integration_expenses_ned.run_callbacks(:save)
        expect(integration_expenses_ned.date_of_issue).to eq(Date.today)
      end
    end

    describe 'after_validation' do

      it 'sets composed_key' do
        expected = "#{ned.exercicio}#{ned.unidade_gestora}#{ned.numero}"
        ned.valid?

        expect(ned.composed_key).to eq(expected)
      end

      it 'sets transfer_type' do
        # Campo item_despesa:

        # a. Transferência a município -  nas posições 3 e 4, onde o valor estejam preenchidos com '40' ou '41'.
        # b. Transferência a entidade sem fins lucrativos - nas posições 3 e 4, onde o valor estejam preenchidos com '50'
        # c. Transferência a entidades com fins lucrativos - nas posições 3 e 4, onde o valor estejam preenchidos com '60'
        # d. Transferências a Instituições Multigovernamentais- nas posições 3 e 4, onde o valor estejam preenchidos com '70'
        # e. Transferências a Consórcios Públicos - nas posições 3 e 4, onde o valor estejam preenchidos com '71'

        transfers = [
          :transfer_none,
          :transfer_cities,
          :transfer_non_profits,
          :transfer_profits,
          :transfer_multi_govs,
          :transfer_consortiums
        ]

        ned = integration_expenses_ned

        ned.item_despesa = '0040000000'
        ned.valid?
        expect(ned.transfer_type).to eq('transfer_cities')

        ned.item_despesa = '0041000000'
        ned.valid?
        expect(ned.transfer_type).to eq('transfer_cities')

        ned.item_despesa = '0050000000'
        ned.valid?
        expect(ned.transfer_type).to eq('transfer_non_profits')

        ned.item_despesa = '0060000000'
        ned.valid?
        expect(ned.transfer_type).to eq('transfer_profits')

        ned.item_despesa = '0070000000'
        ned.valid?
        expect(ned.transfer_type).to eq('transfer_multi_govs')

        ned.item_despesa = '0071000000'
        ned.valid?
        expect(ned.transfer_type).to eq('transfer_consortiums')

        ned.item_despesa = nil
        ned.valid?
        expect(ned.transfer_type).to eq(nil)

        ned.item_despesa = '0099000000'
        ned.valid?
        expect(ned.transfer_type).to eq('transfer_none')
      end
    end

    describe 'after_validation' do
      describe 'calculated columns' do

        let(:base_data) do
          {
            unidade_gestora: '1',
            exercicio: '2010'
          }
        end

        it 'calculated' do
          # A NED tem 3 tipos de natureza: 'Ordinária', 'Anulação' e 'Suplementação'.
          # Para 'Anulação' e 'Suplementação', temos a referência para a ned_ordinaria
          # e precisamos avisá-la que as colunas de calculated_valor_suplementado
          # e calculated_valor_anulado.

          parent_ned = create(:integration_expenses_ned, base_data.merge({ natureza: 'Ordinária', valor: 1000, valor_pago: 500 }))

          suplementado_ned = create(:integration_expenses_ned, base_data.merge({ natureza: 'Suplementação', ned_ordinaria: parent_ned, valor: 50, valor_pago: 25 }))
          another_suplementado_ned = create(:integration_expenses_ned, base_data.merge({ natureza: 'Suplementação', ned_ordinaria: parent_ned, valor: 50, valor_pago: 25 }))

          anulado_ned = create(:integration_expenses_ned, base_data.merge({ natureza: 'Anulação', ned_ordinaria: parent_ned, valor: 5, valor_pago: 2 }))
          another_anulado_ned = create(:integration_expenses_ned, base_data.merge({ natureza: 'Anulação', ned_ordinaria: parent_ned, valor: 5, valor_pago: 2 }))

          # Ordinária:
          #  valor: 1000, valor_pago: 500
          #
          # Suplementado (total das 2 neds)
          #  valor: 100, valor_pago: 50
          #
          # Anulado (total das 2 neds)
          #  valor: 10, valor_pago: 4
          #
          # Final esprado:
          #
          # valor: 1000,
          # valor_pago: 500,
          # calculated_valor_final (valor + suplementado - anulado): 1090
          # calculated_valor_pago_final (valor_pago + suplementado.valor_pago - anulado.valor_pago): 546
          # calculated_valor_suplementado: 100
          # calculated_valor_pago_suplementado: 50
          # calculated_valor_anulado: 10
          # calculated_valor_pago_anulado: 4
          #

          parent_ned.calculated_valor_suplementado = nil
          parent_ned.calculated_valor_pago_suplementado = nil
          parent_ned.calculated_valor_anulado = nil
          parent_ned.calculated_valor_pago_anulado = nil
          parent_ned.calculated_valor_pago_final = nil
          parent_ned.calculated_valor_final = nil

          parent_ned.valid?

          expect(parent_ned.calculated_valor_suplementado).to eq(100)
          expect(parent_ned.calculated_valor_pago_suplementado).to eq(50)
          expect(parent_ned.calculated_valor_anulado).to eq(10)
          expect(parent_ned.calculated_valor_pago_anulado).to eq(4)
          expect(parent_ned.calculated_valor_pago_final).to eq(0)
          expect(parent_ned.calculated_valor_final).to eq(1090)
        end

        it 'calculate valor liquidado and valor pago based on exercicio' do
          # Temos que calcular:
          #
          # 1. Valor Liquidado no Exercício da emissão do Empenho
          # 2. Valor Liquidado em anos posteriores ao da emissão do Empenho
          # 3. Valor pago no Exercício da emissão do Empenho
          # 4. Valor pago em anos posteriores ao da emissão do Empenho
          #

          ned = create(:integration_expenses_ned, base_data.merge({valor_pago: 200}))

          nld_data = base_data.merge({
             ned: ned,
             exercicio_restos_a_pagar: ned.exercicio,
             unidade_gestora: ned.unidade_gestora,
             numero_nota_empenho_despesa: ned.numero
          })

          nld = create(:integration_expenses_nld, nld_data.merge({ valor: 50 }))

          suplementado_nld = create(:integration_expenses_nld, nld_data.merge({ natureza: 'Suplementação', nld_ordinaria: nld, valor: 10 }))
          anulado_nld = create(:integration_expenses_nld, nld_data.merge({ natureza: 'Anulação', nld_ordinaria: nld, valor: 5 }))

          npd = create(:integration_expenses_npd, base_data.merge({ nld: nld, valor: 20 }))

          nld_another_year = create(:integration_expenses_nld, nld_data.merge({ exercicio: ned.exercicio + 1, exercicio_restos_a_pagar: ned.exercicio, valor: 100 }))
          suplementado_nld_another_year = create(:integration_expenses_nld, nld_data.merge({ natureza: 'Suplementação', exercicio: ned.exercicio + 1, exercicio_restos_a_pagar: ned.exercicio, nld_ordinaria: nld_another_year, valor: 20 }))
          anulado_nld_another_year = create(:integration_expenses_nld, nld_data.merge({ natureza: 'Anulação', exercicio: ned.exercicio + 1, exercicio_restos_a_pagar: ned.exercicio, nld_ordinaria: nld_another_year, valor: 10 }))

          npd_another_year = create(:integration_expenses_npd, base_data.merge({ exercicio: nld_another_year.exercicio, numero_nld_ordinaria: nld_another_year.numero, valor: 40 }))

          # Ordinária:
          #  valor: 50
          #
          # Suplementado
          #  valor: 10
          #
          # Anulado
          #  valor: 5
          #
          # Final esprado:
          #
          # valor: 55
          #

          ned.calculated_valor_liquidado_exercicio = nil
          ned.calculated_valor_liquidado_apos_exercicio = nil

          ned.reload
          ned.nlds.reload

          ned.valid?

          expect(ned.calculated_valor_liquidado_exercicio).to eq(55)
          expect(ned.calculated_valor_liquidado_apos_exercicio).to eq(110)
          expect(ned.calculated_valor_pago_exercicio).to eq(0)
          expect(ned.calculated_valor_pago_apos_exercicio).to eq(40)

          # Verifica se valor final considera o pago fora do exercício.
          expect(ned.calculated_valor_pago_final).to eq(ned.npds.ordinarias.sum(:valor) + ned.npds.suplementacoes.sum(:valor) - ned.npds.anulacoes.sum(:valor))
        end
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

        it 'valor_suplementado e valor_anulado on parent ned'  do
          # A NED tem 3 tipos de natureza: 'Ordinária', 'Anulação' e 'Suplementação'.
          # Para 'Anulação' e 'Suplementação', temos a referência para a ned_ordinaria
          # e precisamos avisá-la que as colunas de calculated_valor_suplementado
          # e calculated_valor_anulado.

          parent_ned = create(:integration_expenses_ned, base_data.merge({ natureza: 'Ordinária', valor: 1000, valor_pago: 500 }))

          suplementado_ned = create(:integration_expenses_ned, base_data.merge({ natureza: 'Suplementação', ned_ordinaria: parent_ned, valor: 50, valor_pago: 25 }))
          another_suplementado_ned = create(:integration_expenses_ned, base_data.merge({ natureza: 'Suplementação', ned_ordinaria: parent_ned, valor: 50, valor_pago: 25 }))

          anulado_ned = create(:integration_expenses_ned, base_data.merge({ natureza: 'Anulação', ned_ordinaria: parent_ned, valor: 5, valor_pago: 2 }))
          another_anulado_ned = create(:integration_expenses_ned, base_data.merge({ natureza: 'Anulação', ned_ordinaria: parent_ned, valor: 5, valor_pago: 2 }))

          # Ordinária:
          #  valor: 1000, valor_pago: 500
          #
          # Suplementado (total das 2 neds)
          #  valor: 100, valor_pago: 50
          #
          # Anulado (total das 2 neds)
          #  valor: 10, valor_pago: 4
          #
          # Final esprado:
          #
          # valor: 1000,
          # valor_pago: 500,
          # calculated_valor_final (valor + suplementado - anulado): 1090
          # calculated_valor_pago_final (valor_pago + suplementado.valor_pago - anulado.valor_pago): 546
          # calculated_valor_suplementado: 100
          # calculated_valor_pago_suplementado: 50
          # calculated_valor_anulado: 10
          # calculated_valor_pago_anulado: 4
          #

          expect(suplementado_ned.ned_ordinaria).to eq(parent_ned)

          suplementado_ned.run_callbacks(:commit)

          parent_ned.reload

          expect(parent_ned.calculated_valor_suplementado).to eq(100)
          expect(parent_ned.calculated_valor_pago_suplementado).to eq(50)
          expect(parent_ned.calculated_valor_anulado).to eq(10)
          expect(parent_ned.calculated_valor_pago_anulado).to eq(4)
          expect(parent_ned.calculated_valor_pago_final).to eq(0)
          expect(parent_ned.calculated_valor_final).to eq(1090)
        end
      end
    end

    describe 'classificacao_orcamentaria_completo' do

      it 'classificacao_elemento_despesa' do
        # De acordo com a documentação, o elemento de despesa deve vir de
        # Campo itemdespesa posição 5 e 6.
        ned.item_despesa = '12345678'

        integration_expenses_ned.run_callbacks(:save)

        expect(ned.classificacao_elemento_despesa).to eq('56')
      end

      context 'before 2016' do

        let(:classificacao_orcamentaria_completo) do
          # unidade_orcamentaria
          # funcao
          # subfuncao
          # programa_governo
          # acao_governamental
          # regiao_administrativa
          # natureza_despesa
          # fonte_recursos
          # id_uso
          # tipo_despesa

          # 40100001 28 846 002 01613 2200000 33904700 00 0 2 0
          '40100001288460020161322000003390470000020'
        end

        it 'parses data' do
          integration_expenses_ned.exercicio = 2015
          integration_expenses_ned.classificacao_orcamentaria_completo = classificacao_orcamentaria_completo

          integration_expenses_ned.run_callbacks(:save)

          expect(integration_expenses_ned.classificacao_unidade_orcamentaria).to eq('40100001')
          expect(integration_expenses_ned.classificacao_funcao).to eq('28')
          expect(integration_expenses_ned.classificacao_subfuncao).to eq('846')
          expect(integration_expenses_ned.classificacao_programa_governo).to eq('002')
          expect(integration_expenses_ned.classificacao_acao_governamental).to eq('01613')
          expect(integration_expenses_ned.classificacao_regiao_administrativa).to eq('2200000')
          expect(integration_expenses_ned.classificacao_natureza_despesa).to eq('33904700')
          expect(integration_expenses_ned.classificacao_fonte_recursos).to eq('00')
          expect(integration_expenses_ned.classificacao_id_uso).to eq('0')
          expect(integration_expenses_ned.classificacao_tipo_despesa).to eq('2')

        end
      end

      context '2016 and after' do

        let(:classificacao_orcamentaria_completo) do
          # unidade_orcamentaria
          # funcao
          # subfuncao
          # programa_governo
          # acao_governamental
          # regiao_administrativa
          # natureza_despesa
          # cod_destinacao
          # fonte_recursos
          # subfonte
          # id_uso
          # tipo_despesa

          # 40100001 28 846 059 00647 15 31909100 1 01 00 0 1 000

          '40100001288460590064715319091001010001000'
        end

        it 'parses data' do
          integration_expenses_ned.exercicio = 2016
          integration_expenses_ned.classificacao_orcamentaria_completo = classificacao_orcamentaria_completo

          integration_expenses_ned.run_callbacks(:save)

          expect(integration_expenses_ned.classificacao_unidade_orcamentaria).to eq('40100001')
          expect(integration_expenses_ned.classificacao_funcao).to eq('28')
          expect(integration_expenses_ned.classificacao_subfuncao).to eq('846')
          expect(integration_expenses_ned.classificacao_programa_governo).to eq('059')
          expect(integration_expenses_ned.classificacao_acao_governamental).to eq('00647')
          expect(integration_expenses_ned.classificacao_regiao_administrativa).to eq('15')
          expect(integration_expenses_ned.classificacao_natureza_despesa).to eq('31909100')
          expect(integration_expenses_ned.classificacao_cod_destinacao).to eq('1')
          expect(integration_expenses_ned.classificacao_fonte_recursos).to eq('01')
          expect(integration_expenses_ned.classificacao_subfonte).to eq('00')
          expect(integration_expenses_ned.classificacao_id_uso).to eq('0')
          expect(integration_expenses_ned.classificacao_tipo_despesa).to eq('1')
        end
      end
    end
  end
end
