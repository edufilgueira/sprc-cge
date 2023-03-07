require 'rails_helper'

describe Integration::Expenses::NldItemPaymentPlanning do

  subject(:integration_expenses_nld_item_payment_planning) { build(:integration_expenses_nld_item_payment_planning) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_expenses_nld_item_payment_planning, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:codigo_isn).of_type(:integer) }
      it { is_expected.to have_db_column(:valor_liquidado).of_type(:decimal) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      # Os testes de db:indexes ficam concentrados na aplicação sprc-data
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:nld) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:nld) }
  end

end
