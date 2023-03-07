require 'rails_helper'

describe Integration::Expenses::FundSupply do

  subject(:integration_expenses_fund_supply) { build(:integration_expenses_fund_supply) }

  let(:fund_supply) { integration_expenses_fund_supply }

  # FundSupply é um tipo de Ned

  it { is_expected.to be_kind_of(Integration::Expenses::Ned) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_expenses_fund_supply, :invalid)).to be_invalid }
  end

  describe 'scope' do
    it 'default_scope' do
      fund_supply.save

      another_ned = create(:integration_expenses_ned, item_despesa: '123')

      expect(Integration::Expenses::Ned.count).to eq(2)

      expect(Integration::Expenses::FundSupply.count).to eq(1)
      expect(Integration::Expenses::FundSupply.all).to match_array([fund_supply])
    end
  end
end
