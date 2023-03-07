require 'rails_helper'

describe Integration::Expenses::Daily do

  subject(:integration_expenses_daily) { build(:integration_expenses_daily) }

  let(:nld) { daily.nld }

  let(:ned) { daily.ned }

  let(:daily) { integration_expenses_daily }

  # Daily é um tipo de Npd

  it { is_expected.to be_kind_of(Integration::Expenses::Npd) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_expenses_daily, :invalid)).to be_invalid }
  end

  describe 'scope' do
    it 'default_scope' do
      daily.save

      # importante ter 339014 na posição correta
      # (integration_expenses_neds.exercicio < 2016 AND substring(integration_expenses_neds.classificacao_orcamentaria_completo from 29 for 6) in ('339014','339015','339092','449014','449015','449092')) OR
      # (integration_expenses_neds.exercicio >= 2016 AND substring(integration_expenses_neds.classificacao_orcamentaria_completo from 24 for 6) in ('339014','339015','339092','449014','449015','449092'))

      another_ned = create(:integration_expenses_ned, classificacao_orcamentaria_completo: '123')

      another_daily = create(:integration_expenses_daily)

      expect(Integration::Expenses::Ned.count).to eq(3)

      expect(Integration::Expenses::Daily.count).to eq(2)
      expect(Integration::Expenses::Daily.all).to match_array([daily, another_daily])
    end

    it 'server_salary' do
      daily.save

      server_salary_date = (Date.parse(daily.data_emissao)).beginning_of_month


      registration = build(:integration_servers_registration)
      registration.dsc_cpf = daily.documento_credor
      registration.save

      server_salary = create(:integration_servers_server_salary, date: server_salary_date, registration: registration)

      expect(server_salary.date).to eq(server_salary_date)
      expect(server_salary.registration).to eq(registration)
      expect(registration.dsc_cpf).to eq(daily.documento_credor)
      expect(daily.server_salary).to eq(server_salary)
    end
  end
end
