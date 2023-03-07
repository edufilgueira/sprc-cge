require 'rails_helper'

describe Integration::Contracts::Convenant do

  subject(:convenant) { build(:integration_contracts_convenant) }

  it { is_expected.to be_kind_of(Integration::Contracts::Contract) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_contracts_convenant, :invalid)).to be_invalid }
  end

  describe 'default_scope' do
    it 'returns only convenants' do
      contract = create(:integration_contracts_contract)
      convenant = create(:integration_contracts_convenant)

      expect(Integration::Contracts::Convenant.pluck(:id)).to include(convenant.id)
      expect(Integration::Contracts::Convenant.pluck(:id)).not_to include(contract.id)
    end
  end

  describe 'enums' do
    it 'infringement_status' do
      infringement_statuses = [:adimplente, :inadimplente]

      is_expected.to define_enum_for(:infringement_status).with_values(infringement_statuses)
    end
  end

  describe 'callbacks' do
    it 'change status' do
      convenant.update(valor_original_contrapartida: 0)
      changes_notificables = { 'valor_original_contrapartida'=>['0.0', '10.0'] }

      convenant.save

      convenant.update(valor_original_contrapartida: 10)

      expect(convenant.data_changes).to eq(changes_notificables)
      expect(convenant.resource_status).to eq('updated_resource_notificable')
    end
  end
end
