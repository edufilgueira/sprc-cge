require 'rails_helper'

describe Transparency::Notifications::Integration::Contracts::ContractFollow do
  let(:contract) { create(:integration_contracts_contract) }
  let!(:follower) { create(:transparency_follower, resourceable: contract) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      allow(Transparency::Notifications::Integration::Contracts::ContractFollow).to receive(:call)
      Transparency::Notifications::Integration::Contracts::ContractFollow.call(contract.id)

      expect(Transparency::Notifications::Integration::Contracts::ContractFollow).to have_received(:call).with(contract.id)
    end
  end

  describe 'initialization' do
    it 'responds to notification' do
      service = Transparency::Notifications::Integration::Contracts::ContractFollow.new(contract.id)

      expect(service.contract).to be_an_instance_of(Integration::Contracts::Contract)
    end
  end

  describe 'call' do
    it 'create_email' do
      contract.update(descricao_situacao: 'concluido', data_termino: Date.tomorrow)
      financial = create(:integration_contracts_financial, contract: contract)
      additive = create(:integration_contracts_additive, contract: contract)
      adjustment = create(:integration_contracts_adjustment, contract: contract)

      allow(Transparency::FollowerMailer).to receive(:citizen_following).and_call_original

      service = Transparency::Notifications::Integration::Contracts::ContractFollow.new(contract.id)

      service.call
      contract.reload && financial.reload && additive.reload && adjustment.reload

      expect(Transparency::FollowerMailer).to have_received(:citizen_following)

      expect(contract.resource_status).to eq('resource_notified')
      expect(contract.data_changes).to eq({})

      expect(financial.resource_status).to eq('resource_notified')
      expect(financial.data_changes).to eq({})

      expect(additive.resource_status).to eq('resource_notified')
      expect(additive.data_changes).to eq({})

      expect(adjustment.resource_status).to eq('resource_notified')
      expect(adjustment.data_changes).to eq({})
    end

    it 'utils_data_change nil' do
      financial = create(:integration_contracts_financial, contract: contract)

      allow(Transparency::FollowerMailer).to receive(:citizen_following).and_call_original

      service = Transparency::Notifications::Integration::Contracts::ContractFollow.new(contract.id)

      contract.utils_data_change.destroy

      service.call
      contract.reload && financial.reload

      expect(Transparency::FollowerMailer).to have_received(:citizen_following)
    end

    it 'without changes' do
      financial = create(:integration_contracts_financial, contract: contract)

      allow(Transparency::FollowerMailer).to receive(:citizen_following).and_call_original

      service = Transparency::Notifications::Integration::Contracts::ContractFollow.new(contract.id)

      service.call
      contract.reload && financial.reload

      expect(Transparency::FollowerMailer).to have_received(:citizen_following)
    end
  end
end
