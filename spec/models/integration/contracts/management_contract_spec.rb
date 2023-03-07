require 'rails_helper'

describe Integration::Contracts::ManagementContract do

  subject(:management_contract) { build(:integration_contracts_management_contract) }

  it { is_expected.to be_kind_of(Integration::Contracts::Contract) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_contracts_management_contract, :invalid)).to be_invalid }
  end

  describe 'default_scope' do
    it 'returns only management_contracts' do
      contract = create(:integration_contracts_contract)
      management_contract = create(:integration_contracts_management_contract)

      expect(Integration::Contracts::ManagementContract.pluck(:id)).to include(management_contract.id)
      expect(Integration::Contracts::ManagementContract.pluck(:id)).not_to include(contract.id)
    end
  end

  describe 'callbacks' do
    it 'change status' do
      management_contract.update(data_termino: Date.today)

      management_contract.save

      management_contract.update(data_termino: Date.tomorrow)

      expect(management_contract.data_changes).to be_present
      expect(management_contract.resource_status).to eq('updated_resource_notificable')
    end
  end
end
