require 'rails_helper'

describe Integration::Revenues::Revenue do

  subject(:integration_revenues_revenue) { build(:integration_revenues_revenue) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_revenues_revenue, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:unidade).of_type(:string) }
      it { is_expected.to have_db_column(:poder).of_type(:string) }
      it { is_expected.to have_db_column(:administracao).of_type(:string) }
      it { is_expected.to have_db_column(:conta_contabil).of_type(:string) }
      it { is_expected.to have_db_column(:titulo).of_type(:string) }
      it { is_expected.to have_db_column(:natureza_da_conta).of_type(:string) }
      it { is_expected.to have_db_column(:natureza_credito).of_type(:string) }
      it { is_expected.to have_db_column(:valor_credito).of_type(:decimal) }
      it { is_expected.to have_db_column(:natureza_debito).of_type(:string) }
      it { is_expected.to have_db_column(:valor_debito).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_inicial).of_type(:decimal) }
      it { is_expected.to have_db_column(:natureza_inicial).of_type(:string) }
      it { is_expected.to have_db_column(:fechamento_contabil).of_type(:string) }
      it { is_expected.to have_db_column(:data_atual).of_type(:string) }
      it { is_expected.to have_db_column(:integration_revenues_account_configuration_id).of_type(:integer) }
      it { is_expected.to have_db_column(:integration_supports_organ_id).of_type(:integer) }
      it { is_expected.to have_db_column(:integration_supports_secretary_id).of_type(:integer) }
      it { is_expected.to have_db_column(:month).of_type(:integer) }
      it { is_expected.to have_db_column(:year).of_type(:integer) }

      it { is_expected.to have_db_column(:account_type).of_type(:integer) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:integration_revenues_account_configuration_id) }
      it { is_expected.to have_db_index(:integration_supports_organ_id) }
      it { is_expected.to have_db_index(:integration_supports_secretary_id) }
      it { is_expected.to have_db_index(:account_type) }
    end
  end

  describe 'enums' do
    it 'account_type' do
      expected = [
        :poder_executivo,
        :receitas_lancadas
      ]

      is_expected.to define_enum_for(:account_type).with_values(expected)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:unidade) }
    it { is_expected.to validate_presence_of(:poder) }
    it { is_expected.to validate_presence_of(:administracao) }
    it { is_expected.to validate_presence_of(:conta_contabil) }
    it { is_expected.to validate_presence_of(:titulo) }
    it { is_expected.to validate_presence_of(:natureza_da_conta) }
    it { is_expected.to validate_presence_of(:natureza_credito) }
    it { is_expected.to validate_presence_of(:valor_credito) }
    it { is_expected.to validate_presence_of(:natureza_debito) }
    it { is_expected.to validate_presence_of(:valor_debito) }
    it { is_expected.to validate_presence_of(:valor_inicial) }
    it { is_expected.to validate_presence_of(:fechamento_contabil) }
    it { is_expected.to validate_presence_of(:account_configuration) }
    it { is_expected.to validate_presence_of(:month) }
    it { is_expected.to validate_presence_of(:year) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:accounts).dependent(:destroy) }
    it { is_expected.to belong_to(:account_configuration) }

    context 'existing foreign_keys' do
      it 'organ and secretary'  do

        secretary = create(:integration_supports_organ, :secretary, orgao_sfp: false)
        #
        # O organ deve ser relacionar com a tabela integration_supports_organs.codigo_orgao (orgao_sfp: false)
        # usando sua coluna unidade.
        #
        organ = create(:integration_supports_organ, codigo_orgao: '1234', codigo_entidade: secretary.codigo_entidade, orgao_sfp: false)

        # a flag orgao_sfp é usada para definir órgãos da folha de pagamento. Há sempre 2 órgãos
        # iguais (um com sfp true e outro false),
        organ_sfp = create(:integration_supports_organ, codigo_orgao: '1234', orgao_sfp: true)

        revenue = create(:integration_revenues_revenue, unidade: '1234')

        expect(revenue.organ).to eq(organ)
        expect(revenue.secretary).to eq(secretary)
      end

      it 'organ with data_termino'  do
        # Devemos considerar o órgão de acordo com a data de término
        # Ex:
        # SECRETARIA DA SEGURANÇA PÚBLICA E DEFESA SOCIAL: data_termino: 06/12/2017
        # Como a receita só tem mês/ano, vamos considerar a data_termino do órgão como sendo o final do mês.

        organ = create(:integration_supports_organ, codigo_orgao: '1234', orgao_sfp: false, data_termino: nil)
        revenue = create(:integration_revenues_revenue, unidade: '1234')

        expect(revenue.organ).to eq(organ)

        data_termino = Date.new(revenue.year, revenue.month, 01).end_of_month
        organ_data_termino = create(:integration_supports_organ, codigo_orgao: '1234', orgao_sfp: false, data_termino: data_termino)

        revenue.valid?
        revenue.save

        expect(revenue.reload.organ).to eq(organ_data_termino)
      end
    end
  end

  describe 'nested' do
    it { is_expected.to accept_nested_attributes_for(:accounts) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:title).to(:account_configuration).with_prefix }
    it { is_expected.to delegate_method(:title).to(:organ).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:acronym).to(:organ).with_arguments(allow_nil: true).with_prefix }
  end

  describe 'scope' do
    it 'sorted' do
      first_unsorted = create(:integration_revenues_revenue, unidade: 'DEF')
      last_unsorted = create(:integration_revenues_revenue, unidade: 'ABC')
      expect(Integration::Revenues::Revenue.sorted).to eq([last_unsorted, first_unsorted])
    end

    it 'from_month_and_year' do
      revenue = create(:integration_revenues_revenue)
      create(:integration_revenues_revenue, year: 1900)

      expect(Integration::Revenues::Revenue.from_month_and_year(Date.current.last_month)).to eq([revenue])
    end

    it 'from_year' do
      revenue = create(:integration_revenues_revenue)
      create(:integration_revenues_revenue, year: 1900)

      expect(Integration::Revenues::Revenue.from_year(Date.today.last_month.year)).to eq([revenue])
    end
  end

  describe 'helpers' do
    it 'title' do
      expect(integration_revenues_revenue.title).to eq(integration_revenues_revenue.titulo)
    end
  end

  describe 'callbacks' do
    describe 'account_type' do
      it 'sets account_type based on conta_contabil' do

        revenue = integration_revenues_revenue

        poder_executivo = ['5.2.1.1', '5.2.1.1.1', '5.2.1.2.1', '5.2.1.2.1.0.1', '5.2.1.2.1.0.2', '5.2.1.2.9', '6.2.1.2', '6.2.1.3']
        receitas_lancadas = ['4.1.1.2.1.03.01', '4.1.1.2.1.97.01', '4.1.1.2.1.97.11']

        poder_executivo.each do |conta_contabil|
          revenue.conta_contabil = conta_contabil
          revenue.valid?

          expect(revenue).to be_poder_executivo
        end

        receitas_lancadas.each do |conta_contabil|
          revenue.conta_contabil = conta_contabil
          revenue.valid?

          expect(revenue).to be_receitas_lancadas
        end
      end
    end
  end
end
