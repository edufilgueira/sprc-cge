require 'rails_helper'

describe Integration::Revenues::AccountConfiguration do

  subject(:account_configuration) { build(:integration_revenues_account_configuration) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_revenues_account_configuration, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:account_number).of_type(:string) }
      it { is_expected.to have_db_column(:title).of_type(:string) }
      it { is_expected.to have_db_column(:integration_revenues_configuration_id).of_type(:integer) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:configuration) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:account_number) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:configuration) }
  end

  describe 'scope' do
    it 'sorted' do
      expect(Integration::Revenues::AccountConfiguration.sorted).to eq(Integration::Revenues::AccountConfiguration.order(:title))
    end
  end
end
