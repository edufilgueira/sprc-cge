require 'rails_helper'

describe Integration::Supports::AdministrativeRegion do
  subject(:administrative_region) { build(:integration_supports_administrative_region) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_administrative_region, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:codigo_regiao).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_regiao_resumido).of_type(:string) }
      it { is_expected.to have_db_column(:titulo).of_type(:string) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:codigo_regiao) }
      it { is_expected.to have_db_index(:codigo_regiao_resumido) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:codigo_regiao) }
    it { is_expected.to validate_presence_of(:titulo) }
  end

  describe 'callbacks' do
    describe 'after_validation' do
      it 'sets codigo_regiao_resumido' do
        # As Despesas do Poder Executivo (Integration::Expenses::BudgetBalance)
        # usam um código reduzido na coluna 'cod_localizacao_gasto'.
        # Ex: cod_localizacao_gasto: 15
        #     codigo_regiao: 1500000

        administrative_region.codigo_regiao = '1500000'
        administrative_region.valid?

        expect(administrative_region.codigo_regiao_resumido).to eq('15')

        # Não coloca o valor caso seja região que não termina em '000000'
        administrative_region.codigo_regiao = '1510000'
        administrative_region.valid?

        expect(administrative_region.codigo_regiao_resumido).to eq(nil)
      end
    end
  end

  describe 'helpers' do
    it 'title' do
      expect(administrative_region.title).to eq(administrative_region.titulo)
    end
  end
end
