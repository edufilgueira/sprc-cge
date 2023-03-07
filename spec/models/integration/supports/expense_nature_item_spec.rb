require 'rails_helper'

describe Integration::Supports::ExpenseNatureItem do
  subject(:expense_nature_item) { build(:integration_supports_expense_nature_item) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_expense_nature_item, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:codigo_item_natureza).of_type(:string) }
      it { is_expected.to have_db_column(:titulo).of_type(:string) }
    end

    describe 'indexes' do
      # Os testes de db:indexes ficam concentrados na aplicação sprc-data
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:codigo_item_natureza) }
    it { is_expected.to validate_presence_of(:titulo) }
  end

  describe 'helpers' do
    it 'title' do
      expect(expense_nature_item.title).to eq(expense_nature_item.titulo)
    end
  end
end
