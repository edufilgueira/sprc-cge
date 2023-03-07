require 'rails_helper'

describe Integration::Expenses::NonProfitTransfer do

  subject(:integration_expenses_non_profit_transfer) { build(:integration_expenses_non_profit_transfer) }

  let(:non_profit) { integration_expenses_non_profit_transfer }

  # NonProfitTransfer é um tipo de Ned

  it { is_expected.to be_kind_of(Integration::Expenses::Ned) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_expenses_non_profit_transfer, :invalid)).to be_invalid }
  end

  describe 'scope' do
    it 'default_scope' do
      non_profit.save

      another_ned = create(:integration_expenses_ned, item_despesa: '123')

      expect(Integration::Expenses::Ned.count).to eq(2)

      expect(Integration::Expenses::NonProfitTransfer.count).to eq(1)
      expect(Integration::Expenses::NonProfitTransfer.all).to match_array([non_profit])
    end
  end
end
