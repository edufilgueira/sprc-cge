require 'rails_helper'

describe Integration::Expenses::ConsortiumTransfer do

  subject(:integration_expenses_consortium_transfer) { build(:integration_expenses_consortium_transfer) }

  let(:consortium) { integration_expenses_consortium_transfer }

  # ConsortiumTransfer é um tipo de Ned

  it { is_expected.to be_kind_of(Integration::Expenses::Ned) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_expenses_consortium_transfer, :invalid)).to be_invalid }
  end

  describe 'scope' do
    it 'default_scope' do
      consortium.save

      another_ned = create(:integration_expenses_ned, item_despesa: '123')

      expect(Integration::Expenses::Ned.count).to eq(2)

      expect(Integration::Expenses::ConsortiumTransfer.count).to eq(1)
      expect(Integration::Expenses::ConsortiumTransfer.all).to match_array([consortium])
    end
  end
end
