require 'rails_helper'

describe Transparency::Notifications::Integration::Contracts::ManagementContractFollow do
  let(:management_contract) { create(:integration_contracts_management_contract) }
  let!(:follower) { create(:transparency_follower, resourceable: management_contract, resourceable_type: 'Integration::Contracts::ManagementContract') }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      allow(Transparency::Notifications::Integration::Contracts::ManagementContractFollow).to receive(:call)
      Transparency::Notifications::Integration::Contracts::ManagementContractFollow.call(management_contract.id)

      expect(Transparency::Notifications::Integration::Contracts::ManagementContractFollow).to have_received(:call).with(management_contract.id)
    end
  end

  describe 'initialization' do
    it 'responds to notification' do
      service = Transparency::Notifications::Integration::Contracts::ManagementContractFollow.new(management_contract.id)

      expect(service.management_contract).to be_an_instance_of(Integration::Contracts::ManagementContract)
    end
  end

  describe 'call' do
    it 'create_email' do
      management_contract.update(descricao_situacao: 'concluido', data_termino: Date.tomorrow)
      financial = create(:integration_contracts_financial, contract: management_contract)
      additive = create(:integration_contracts_additive, contract: management_contract)
      adjustment = create(:integration_contracts_adjustment, contract: management_contract)

      allow(Transparency::FollowerMailer).to receive(:citizen_following).and_call_original

      service = Transparency::Notifications::Integration::Contracts::ManagementContractFollow.new(management_contract.id)

      service.call
      management_contract.reload && financial.reload && additive.reload && adjustment.reload

      expect(Transparency::FollowerMailer).to have_received(:citizen_following)

      expect(management_contract.resource_status).to eq('resource_notified')
      expect(management_contract.data_changes).to eq({})

      expect(financial.resource_status).to eq('resource_notified')
      expect(financial.data_changes).to eq({})

      expect(additive.resource_status).to eq('resource_notified')
      expect(additive.data_changes).to eq({})

      expect(adjustment.resource_status).to eq('resource_notified')
      expect(adjustment.data_changes).to eq({})
    end

    it 'without changes' do
      adjustment = create(:integration_contracts_adjustment, contract: management_contract)

      allow(Transparency::FollowerMailer).to receive(:citizen_following).and_call_original

      service = Transparency::Notifications::Integration::Contracts::ManagementContractFollow.new(management_contract.id)

      service.call
      management_contract.reload && adjustment.reload

      expect(Transparency::FollowerMailer).to have_received(:citizen_following)
    end
  end
end
