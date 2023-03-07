require 'rails_helper'

describe Integration::Supports::Organ do
  subject(:organ) { build(:integration_supports_organ) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_organ, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:codigo_orgao).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_orgao).of_type(:string) }
      it { is_expected.to have_db_column(:sigla).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_entidade).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_entidade).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_administracao).of_type(:string) }
      it { is_expected.to have_db_column(:poder).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_folha_pagamento).of_type(:string) }
      it { is_expected.to have_db_column(:orgao_sfp).of_type(:boolean) }

      it { is_expected.to have_db_column(:data_inicio).of_type(:date) }
      it { is_expected.to have_db_column(:data_termino).of_type(:date) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:codigo_entidade) }
      it { is_expected.to have_db_index(:codigo_folha_pagamento) }
      it { is_expected.to have_db_index(:codigo_orgao) }
      it { is_expected.to have_db_index(:orgao_sfp) }
      it { is_expected.to have_db_index(:sigla) }
      it { is_expected.to have_db_index(:data_inicio) }
      it { is_expected.to have_db_index(:data_termino) }
    end
  end

  describe 'associations' do
    it 'server_salaries' do
      expect(subject).to have_many(:server_salaries).
        with_foreign_key('integration_supports_organ_id').
        class_name('Integration::Servers::ServerSalary')
    end

    it 'organ_server_roles' do
      expect(subject).to have_many(:organ_server_roles).
        with_foreign_key('integration_supports_organ_id').
        class_name('Integration::Supports::OrganServerRole')
    end

    it 'roles' do
      expect(subject).to have_many(:roles).through(:organ_server_roles).
        class_name('Integration::Supports::ServerRole')
    end

    it 'organs' do
      # Uma secretaria tem vários órgãos com o mesmo 'codigo_entidade'

      secretary = create(:integration_supports_organ, :secretary)

      organ = create(:integration_supports_organ, codigo_entidade: secretary.codigo_entidade)

      expect(secretary.organs).to eq([organ])
      expect(organ.organs).to eq([])
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:codigo_orgao) }
    it { is_expected.to validate_presence_of(:descricao_orgao) }
  end

  describe 'scope' do
    it 'sorted' do
      first_unsorted = create(:integration_supports_organ, descricao_orgao: 'HOSPITAL GERAL DA POLÍCIA MILITAR JOSÉ MARTINIANO DE ALENCAR')
      last_unsorted = create(:integration_supports_organ, descricao_orgao: 'SUPERINDENT DO DESENV URBANO DO ESTADO DO CEARA')
      expect(Integration::Supports::Organ.sorted).to eq([first_unsorted, last_unsorted])
    end

    it 'secretaries' do
      organ = create(:integration_supports_organ)
      secretary = create(:integration_supports_organ, :secretary)

      expect(Integration::Supports::Organ.secretaries).to eq([secretary])
    end

    it 'organs' do
      organ = create(:integration_supports_organ)
      secretary = create(:integration_supports_organ, :secretary)

      expect(Integration::Supports::Organ.organs).to eq([organ])
    end
  end

  describe 'helpers' do
    it 'title' do
      expect(organ.title).to eq(organ.descricao_orgao)
    end

    it 'acronym' do
      expect(organ.acronym).to eq(organ.sigla)
    end
  end

  describe 'callbacks' do
    describe 'after_validation' do

      # Grava uma flag para dizer se o órgão é uma secretaria. A única
      # informação que temos é quando o campo 'codigo_orgao' terminar em '0001'

      it 'secretary' do
        organ.codigo_orgao = '11001'

        organ.valid?

        expect(organ).not_to be_secretary

        organ.codigo_orgao = '110001'

        organ.valid?

        expect(organ).to be_secretary
      end

      it 'secretary when descricao_orgao and descricao_entidade are the same' do
        organ.codigo_orgao = 191011
        organ.descricao_orgao = "ENCARGOS GERAIS DO ESTADO"
        organ.descricao_entidade = "ENCARGOS GERAIS DO ESTADO"

        organ.valid?

        expect(organ).to be_secretary
      end
    end
  end
end
