require 'rails_helper'

describe Integration::Expenses::NedPlanningItem do

  subject(:integration_expenses_ned_planning_item) { build(:integration_expenses_ned_planning_item) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_expenses_ned_planning_item, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:isn_item_parcela).of_type(:integer) }
      it { is_expected.to have_db_column(:valor).of_type(:decimal) }

      it { is_expected.to have_db_column(:integration_expenses_ned_id).of_type(:integer) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      # Os testes de db:indexes ficam concentrados na aplicação sprc-data
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:ned) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:ned) }
  end

  describe 'scope' do
    it 'sorted' do
      first_unsorted = create(:integration_expenses_ned_planning_item, valor: '123')
      last_unsorted = create(:integration_expenses_ned_planning_item, valor: '321')
      expect(Integration::Expenses::NedPlanningItem.sorted).to eq([first_unsorted, last_unsorted])
    end
  end

end
