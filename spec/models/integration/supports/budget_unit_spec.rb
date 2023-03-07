require 'rails_helper'

describe Integration::Supports::BudgetUnit do
  subject(:budget_unit) { build(:integration_supports_budget_unit) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_budget_unit, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:codigo_unidade_gestora).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_unidade_orcamentaria).of_type(:string) }
      it { is_expected.to have_db_column(:titulo).of_type(:string) }
    end

    describe 'indexes' do
      # Os testes de db:indexes ficam concentrados na aplicação sprc-data
    end
  end

  describe 'association' do
    it { is_expected.to belong_to(:management_unit).class_name('Integration::Supports::ManagementUnit').with_foreign_key(:codigo_unidade_gestora).with_primary_key(:codigo) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:codigo_unidade_gestora) }
    it { is_expected.to validate_presence_of(:codigo_unidade_orcamentaria) }
    it { is_expected.to validate_presence_of(:titulo) }
  end

  describe 'helpers' do
    it 'title' do
      expect(budget_unit.title).to eq(budget_unit.titulo)
    end
  end
end
