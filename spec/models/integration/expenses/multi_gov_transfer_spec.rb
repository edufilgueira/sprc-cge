require 'rails_helper'

describe Integration::Expenses::MultiGovTransfer do

  subject(:integration_expenses_multi_gov_transfer) { build(:integration_expenses_multi_gov_transfer) }

  let(:multi_gov) { integration_expenses_multi_gov_transfer }

  # MultiGovTransfer é um tipo de Ned

  it { is_expected.to be_kind_of(Integration::Expenses::Ned) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_expenses_multi_gov_transfer, :invalid)).to be_invalid }
  end

  describe 'scope' do
    it 'default_scope' do
      multi_gov.save

      another_ned = create(:integration_expenses_ned, item_despesa: '123')

      expect(Integration::Expenses::Ned.count).to eq(2)

      expect(Integration::Expenses::MultiGovTransfer.count).to eq(1)
      expect(Integration::Expenses::MultiGovTransfer.all).to match_array([multi_gov])
    end
  end
end
