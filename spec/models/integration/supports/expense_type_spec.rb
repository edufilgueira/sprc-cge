require 'rails_helper'

describe Integration::Supports::ExpenseType do
  subject(:expense_type) { build(:integration_supports_expense_type) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_expense_type, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:codigo).of_type(:string) }
    end

    describe 'indexes' do
      # Os testes de db:indexes ficam concentrados na aplicação sprc-data
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:codigo) }
  end

  describe 'helpers' do
    it 'title' do
      expect(expense_type.title).to eq(expense_type.codigo)
    end
  end
end
