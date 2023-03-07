require 'rails_helper'

describe Integration::Revenues::Account do

  subject(:integration_revenues_account) { build(:integration_revenues_account) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_revenues_account, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:conta_corrente).of_type(:string) }
      it { is_expected.to have_db_column(:natureza_credito).of_type(:string) }
      it { is_expected.to have_db_column(:valor_credito).of_type(:decimal) }
      it { is_expected.to have_db_column(:natureza_debito).of_type(:string) }
      it { is_expected.to have_db_column(:valor_debito).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_inicial).of_type(:decimal) }
      it { is_expected.to have_db_column(:natureza_inicial).of_type(:string) }
      it { is_expected.to have_db_column(:mes).of_type(:string) }
      it { is_expected.to have_db_column(:integration_revenues_revenue_id).of_type(:integer) }
      it { is_expected.to have_db_column(:codigo_natureza_receita).of_type(:string) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:conta_corrente) }
      it { is_expected.to have_db_index(:integration_revenues_revenue_id) }
      it { is_expected.to have_db_index(:codigo_natureza_receita) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:conta_corrente) }
    it { is_expected.to validate_presence_of(:natureza_credito) }
    it { is_expected.to validate_presence_of(:valor_credito) }
    it { is_expected.to validate_presence_of(:natureza_debito) }
    it { is_expected.to validate_presence_of(:valor_debito) }
    it { is_expected.to validate_presence_of(:valor_inicial) }
    it { is_expected.to validate_presence_of(:mes) }
    it { is_expected.to validate_presence_of(:revenue) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:revenue) }

    # Associação com RevenueNature se dá pela primeira parte do número da conta
    # Ex: '112109951.20600' -> '112109951'. Esse código é gravado no callback
    # na coluna codigo_natureza_receita
    it { is_expected.to belong_to(:revenue_nature).with_foreign_key(:codigo_natureza_receita).with_primary_key(:codigo) }
  end

  describe 'callbacks' do
    describe 'after_validation' do
      it 'sets codigo_natureza_receita' do
        integration_revenues_account.conta_corrente = '12345678.55555'
        integration_revenues_account.valid?

        expect(integration_revenues_account.codigo_natureza_receita).to eq('12345678')
      end
    end
  end

  describe 'scope' do
    it 'sorted' do
      first_unsorted = create(:integration_revenues_account, conta_corrente: 'DEF')
      last_unsorted = create(:integration_revenues_account, conta_corrente: 'ABC')
      expect(Integration::Revenues::Account.sorted).to eq([last_unsorted, first_unsorted])
    end

    it 'from_month_range' do
      date = Date.today
      month = date.month
      month_start = 1
      month_end = date.month
      year = date.year

      revenue_nature = create(:integration_supports_revenue_nature, codigo: '112109953')
      revenue = create(:integration_revenues_revenue, year: year, month: month)
      account = create(:integration_revenues_account, revenue: revenue, conta_corrente: "#{revenue_nature.codigo}.20500", mes: month_end)


      expect(Integration::Revenues::Account.from_month_range(month_start, month_end, year)).to eq([account])
    end
  end

  describe 'helpers' do
    it 'title' do
      expect(integration_revenues_account.title).to eq(integration_revenues_account.conta_corrente)
    end
  end
end
