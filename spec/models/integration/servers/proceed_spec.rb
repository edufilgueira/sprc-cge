require 'rails_helper'

describe Integration::Servers::Proceed do

  subject(:integration_servers_proceed) { build(:integration_servers_proceed) }

  let(:proceed) { integration_servers_proceed }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_servers_proceed, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:cod_orgao).of_type(:string) }
      it { is_expected.to have_db_column(:dsc_matricula).of_type(:string) }
      it { is_expected.to have_db_column(:num_ano).of_type(:integer) }
      it { is_expected.to have_db_column(:num_mes).of_type(:integer) }
      it { is_expected.to have_db_column(:cod_processamento).of_type(:string) }
      it { is_expected.to have_db_column(:cod_provento).of_type(:string) }
      it { is_expected.to have_db_column(:vlr_financeiro).of_type(:decimal) }
      it { is_expected.to have_db_column(:vlr_vencimento).of_type(:decimal) }

      # Fazemos a concatenação de cod_orgao e dsc_matricula para usar de
      # chave no belongs_to. Pois se passarmos o bloco na relação, não podemos
      # fazer o join e carregar tudo junto.
      it { is_expected.to have_db_column(:full_matricula).of_type(:string) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:num_ano) }
      it { is_expected.to have_db_index(:num_mes) }
      it { is_expected.to have_db_index(:cod_provento) }
      it { is_expected.to have_db_column(:full_matricula).of_type(:string) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:registration) }
    it { is_expected.to belong_to(:proceed_type) }

    it 'registration' do
      # first_organ = create(:integration_supports_organ, orgao_sfp: true, codigo_folha_pagamento: '123')
      # second_organ = create(:integration_supports_organ, orgao_sfp: true, codigo_folha_pagamento: '456')

      proceed = integration_servers_proceed

      first_registration = create(:integration_servers_registration, cod_orgao: '123', dsc_matricula: '456')
      second_registration = create(:integration_servers_registration, cod_orgao: '789', dsc_matricula: '101112')
      first_registration.update_attributes({cod_orgao: '123', full_matricula: '123/456'})
      second_registration.update_attributes({cod_orgao: '789', full_matricula: '789/101112'})

      # trocamos o atributo e a matrícula deve ser nil!
      proceed.cod_orgao = '123'
      proceed.dsc_matricula = '101112'
      proceed.valid?
      expect(proceed.registration).to be_blank

      # deve ser first_registration
      proceed.cod_orgao = '123'
      proceed.dsc_matricula = '456'
      proceed.valid?
      expect(proceed.registration).to eq(first_registration)

      # deve ser second_registration
      proceed.cod_orgao = '789'
      proceed.dsc_matricula = '101112'
      proceed.valid?
      expect(proceed.registration).to eq(second_registration)

    end
  end

  describe 'delegations' do
    it { is_expected.to respond_to(:proceed_type) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:cod_orgao) }
    it { is_expected.to validate_presence_of(:dsc_matricula) }
    it { is_expected.to validate_presence_of(:num_ano) }
    it { is_expected.to validate_presence_of(:num_mes) }
    it { is_expected.to validate_presence_of(:cod_processamento) }
    it { is_expected.to validate_presence_of(:cod_provento) }
    it { is_expected.to validate_presence_of(:vlr_financeiro) }
    it { is_expected.to validate_presence_of(:vlr_vencimento) }
  end

  describe 'scope' do
    it 'sorted' do
      expect(Integration::Servers::Proceed.sorted).to eq(Integration::Servers::Proceed.order(:cod_provento))
    end

    it 'from_period' do
      proceed = create(:integration_servers_proceed)
      create(:integration_servers_proceed, num_ano: 1900)

      expect(Integration::Servers::Proceed.from_period(Date.current.last_month)).to eq([proceed])
    end

    it 'from_month_and_year' do
      proceed = create(:integration_servers_proceed)
      create(:integration_servers_proceed, num_ano: 1900)

      last_month = Date.current.last_month

      expect(Integration::Servers::Proceed.from_month_and_year(last_month.month, last_month.year)).to eq([proceed])
    end

    it 'credit' do
      proceed = create(:integration_servers_proceed, :credit)
      create(:integration_servers_proceed, :debit)

      expect(Integration::Servers::Proceed.credit).to eq([proceed])
    end

    it 'debit' do
      proceed = create(:integration_servers_proceed, :debit)
      create(:integration_servers_proceed, :credit)

      expect(Integration::Servers::Proceed.debit).to eq([proceed])
    end

    it 'credit_sum' do
      create(:integration_servers_proceed, :debit)
      proceed = create(:integration_servers_proceed, :credit)
      other_proceed = create(:integration_servers_proceed, :credit)

      expected = proceed.vlr_financeiro + other_proceed.vlr_financeiro

      expect(Integration::Servers::Proceed.credit_sum).to eq(expected)
    end

    it 'debit_sum' do
      create(:integration_servers_proceed, :credit)
      proceed = create(:integration_servers_proceed, :debit)
      other_proceed = create(:integration_servers_proceed, :debit)

      expected = proceed.vlr_financeiro + other_proceed.vlr_financeiro

      expect(Integration::Servers::Proceed.debit_sum).to eq(expected)
    end
  end

  describe 'callbacks' do
    describe 'after_validation' do
      it 'sets full_matricula' do
        proceed.valid?
        expect(proceed.full_matricula).to eq("#{proceed.cod_orgao}/#{proceed.dsc_matricula}")
      end
    end
  end

  describe 'helpers' do
    it 'title' do
      expect(integration_servers_proceed.title).to eq(integration_servers_proceed.cod_provento)
    end
  end
end
