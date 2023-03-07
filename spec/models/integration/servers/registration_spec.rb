require 'rails_helper'

describe Integration::Servers::Registration do

  subject(:integration_servers_registration) { build(:integration_servers_registration) }

  let(:registration) { integration_servers_registration }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_servers_registration, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:dsc_matricula).of_type(:string) }
      it { is_expected.to have_db_column(:dsc_cpf).of_type(:string) }
      it { is_expected.to have_db_column(:dsc_funcionario).of_type(:string) }
      it { is_expected.to have_db_column(:cod_orgao).of_type(:string) }
      it { is_expected.to have_db_column(:dsc_cargo).of_type(:string) }
      it { is_expected.to have_db_column(:num_folha).of_type(:string) }
      it { is_expected.to have_db_column(:cod_situacao_funcional).of_type(:string) }
      it { is_expected.to have_db_column(:cod_afastamento).of_type(:string) }
      it { is_expected.to have_db_column(:vlr_carga_horaria).of_type(:decimal) }
      it { is_expected.to  have_db_column(:dth_nascimento).of_type(:date) }
      it { is_expected.to have_db_column(:dth_afastamento).of_type(:date) }
      it { is_expected.to have_db_column(:vdth_admissao).of_type(:date) }
      it { is_expected.to have_db_column(:status_situacao_funcional).of_type(:string) }
      it { is_expected.to have_db_column(:functional_status).of_type(:integer) }

      it { is_expected.to have_db_column(:active_functional_status).of_type(:boolean) }

      # Fazemos a concatenação de cod_orgao e dsc_matricula para usar de
      # chave no belongs_to. Pois se passarmos o bloco na relação, não podemos
      # fazer o join e carregar tudo junto.
      it { is_expected.to have_db_column(:full_matricula).of_type(:string) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:cod_situacao_funcional) }
      it { is_expected.to have_db_index(:dsc_cpf) }
      it { is_expected.to have_db_index(:dsc_matricula) }
      it { is_expected.to have_db_index(:dsc_matricula) }
      it { is_expected.to have_db_index(:functional_status) }
      it { is_expected.to have_db_index(:status_situacao_funcional) }
      it { is_expected.to have_db_index(:active_functional_status) }
      it { is_expected.to have_db_column(:full_matricula).of_type(:string) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:dsc_matricula) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:organ).with_primary_key(:codigo_folha_pagamento).with_foreign_key(:cod_orgao).class_name('Integration::Supports::Organ') }
    it { is_expected.to belong_to(:server).with_primary_key(:dsc_cpf).with_foreign_key(:dsc_cpf).class_name('Integration::Servers::Server') }
    it { is_expected.to have_many(:proceeds).class_name('Integration::Servers::Proceed').dependent(:destroy) }
    it { is_expected.to have_many(:server_salaries).class_name('Integration::Servers::ServerSalary').dependent(:destroy) }
  end

  describe 'enums' do
    it 'functional_status' do
      functional_statuses = [
        :functional_status_active,
        :functional_status_retired,
        :functional_status_pensioner,
        :functional_status_intern
      ]

      is_expected.to define_enum_for(:functional_status).with_values(functional_statuses)
    end
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:acronym).to(:organ).with_prefix }
    it { is_expected.to delegate_method(:orgao_sfp?).to(:organ) }
  end

  describe 'scope' do
    it 'sorted' do
      first_unsorted = create(:integration_servers_registration, vdth_admissao: Date.yesterday)
      last_unsorted = create(:integration_servers_registration, vdth_admissao: Date.today)
      expect(Integration::Servers::Registration.sorted).to eq([last_unsorted, first_unsorted])
    end

    it 'active' do
      active = create(:integration_servers_registration)
      create(:integration_servers_registration, cod_situacao_funcional: '7')

      expect(Integration::Servers::Registration.active).to eq([active])
    end

    it 'inactive' do
      active = create(:integration_servers_registration)
      inactive = create(:integration_servers_registration, cod_situacao_funcional: '7')
      inactive_cpf = build(:integration_servers_registration, cod_situacao_funcional: '1', dsc_cpf: '00000000000')
      inactive_cpf.dsc_cpf = '00000000000'
      inactive_cpf.save

      result = Integration::Servers::Registration.inactive

      expect(result).to include(inactive)
      expect(result).to include(inactive_cpf)
      expect(result).not_to include(active)
    end
  end

  describe 'helpers' do
    let(:date) { Date.current }
    let(:year) { date.year }
    let(:month) { date.month }

    let(:registration) do
      registration = create(:integration_servers_registration, cod_orgao: '123', dsc_matricula: '456')
      registration.update_attributes({cod_orgao: '123', full_matricula: '123/456'})
      registration
    end

    it 'credit_proceeds' do
      registration
      proceed = create(:integration_servers_proceed, :credit, cod_orgao: '123', dsc_matricula: '456', num_ano: year, num_mes: month, vlr_financeiro: 9999.99)

      expect(proceed.registration).to eq(registration)
      expect(registration.proceeds).to eq([proceed])
      expect(registration.credit_proceeds(date).credit_sum).to eq(9999.99)
    end

    it 'debit_proceeds' do
      proceed = create(:integration_servers_proceed, :debit, cod_orgao: '123', dsc_matricula: '456', num_ano: year, num_mes: month, vlr_financeiro: 9999.99)

      expect(registration.debit_proceeds(date).debit_sum).to eq(9999.99)
    end

    it 'total_salary' do
      proceed = create(:integration_servers_proceed, :credit, cod_orgao: '123', dsc_matricula: '456', num_ano: year, num_mes: month, vlr_financeiro: 9999.99)

      expect(registration.total_salary(date)).to eq(9999.99)
    end

    it 'title' do
      expected = "#{integration_servers_registration.dsc_matricula} - #{integration_servers_registration.organ_acronym}"
      expect(integration_servers_registration.title).to eq(expected)
    end

    it 'title_with_organ_and_role' do
      expected = "#{integration_servers_registration.dsc_funcionario} - #{integration_servers_registration.organ_acronym} - #{integration_servers_registration.dsc_cargo}"
      expect(integration_servers_registration.title_with_organ_and_role).to eq(expected)
    end

    describe 'active' do
      let(:registration) { build(:integration_servers_registration, cod_situacao_funcional: '0', dsc_cpf: '12345678911') }

      before { registration.valid? }

      it 'cod_situacao_funcional' do
        expect(registration.active?).to eq(true)
      end

      it 'dsc_cpf' do
        expect(registration.active?).to eq(true)
      end
    end

    describe 'inactive' do
      let(:registration) { build(:integration_servers_registration) }

      it 'cod_situacao_funcional' do
        # possui cpf correto mas situação funcional inativa
        registration.dsc_cpf = '12345678911'
        registration.cod_situacao_funcional = '7'
        registration.valid?

        expect(registration.active?).to eq(false)
      end

      it 'dsc_cpf' do
        # possui situação funcional ativa mas cpf em branco
        registration.dsc_cpf = '00000000000'
        registration.cod_situacao_funcional = '1'
        registration.valid?

        expect(registration.active?).to eq(false)
      end
    end
  end

  describe 'constants' do
    context 'COD_SITUATION' do
      it 'inactive' do
        expected = %w[7]

        expect(Integration::Servers::Registration::COD_SITUATION_INACTIVE).to eq(expected)
      end

      it 'active' do
        expected = %w[0 1 2 3 4 5 6 8]

        expect(Integration::Servers::Registration::COD_SITUATION_ACTIVE).to eq(expected)
      end
    end
  end

  describe 'callbacks' do
    describe 'after_validation' do
      it 'sets functional_status' do

        # ativos

        registration.functional_status = nil
        registration.status_situacao_funcional = 'ATIVO'
        registration.valid?

        expect(registration.functional_status).to eq('functional_status_active')

        registration.functional_status = nil
        registration.status_situacao_funcional = 'AGUARDANDO APOSENTADORIA'
        registration.valid?

        expect(registration.functional_status).to eq('functional_status_active')


        registration.functional_status = nil
        registration.status_situacao_funcional = 'TEMPORARIO'
        registration.valid?

        expect(registration.functional_status).to eq('functional_status_active')

        registration.functional_status = nil
        registration.status_situacao_funcional = 'SESA/CS'
        registration.valid?

        expect(registration.functional_status).to eq('functional_status_active')

        # aposentados

        registration.functional_status = nil
        registration.status_situacao_funcional = 'APOSENTADO'
        registration.valid?

        expect(registration.functional_status).to eq('functional_status_retired')

        # pensionistas

        registration.functional_status = nil
        registration.status_situacao_funcional = 'PENSIONISTA'
        registration.valid?

        expect(registration.functional_status).to eq('functional_status_pensioner')

        # estagiários

        registration.functional_status = nil
        registration.status_situacao_funcional = 'ESTAGIARIO/BOLSISTA'
        registration.valid?

        expect(registration.functional_status).to eq('functional_status_intern')


        # outro valor

        registration.functional_status = nil
        registration.status_situacao_funcional = 'bla'
        registration.valid?

        expect(registration.functional_status).to eq(nil)

      end

      it 'sets active_functional_status' do
        actives = Integration::Servers::Registration::COD_SITUATION_ACTIVE
        inactives = Integration::Servers::Registration::COD_SITUATION_INACTIVE

        actives.each do |cod_situacao_funcional|
          registration.cod_situacao_funcional = cod_situacao_funcional
          registration.valid?
          expect(registration.active_functional_status).to eq(true)
        end

        inactives.each do |cod_situacao_funcional|
          registration.cod_situacao_funcional = cod_situacao_funcional
          registration.valid?
          expect(registration.active_functional_status).to eq(false)
        end

        # CPF em branco.
        registration.cod_situacao_funcional = actives.first
        registration.dsc_cpf = Integration::Servers::Registration::BLANK_CPF
        registration.valid?
        expect(registration.active_functional_status).to eq(false)
      end

      it 'sets full_matricula' do
        registration.valid?
        expect(registration.full_matricula).to eq("#{registration.cod_orgao}/#{registration.dsc_matricula}")
      end
    end
  end
end
