require 'rails_helper'

describe Transparency::Notifications::Integration::Contracts::ConvenantFollow do
  let(:convenant) { create(:integration_contracts_convenant) }
  let!(:follower) { create(:transparency_follower, resourceable: convenant, resourceable_type: 'Integration::Contracts::Convenant') }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      allow(Transparency::Notifications::Integration::Contracts::ConvenantFollow).to receive(:call)
      Transparency::Notifications::Integration::Contracts::ConvenantFollow.call(convenant.id)

      expect(Transparency::Notifications::Integration::Contracts::ConvenantFollow).to have_received(:call).with(convenant.id)
    end
  end

  describe 'initialization' do
    it 'responds to notification' do
      service = Transparency::Notifications::Integration::Contracts::ConvenantFollow.new(convenant.id)

      expect(service.convenant).to be_an_instance_of(Integration::Contracts::Convenant)
    end
  end

  describe 'call' do
    it 'create_email' do
      convenant.update(descricao_situacao: 'concluido', data_termino: Date.tomorrow)
      financial = create(:integration_contracts_financial, contract: convenant)
      additive = create(:integration_contracts_additive, contract: convenant)
      adjustment = create(:integration_contracts_adjustment, contract: convenant)
      transfer_bank_order = create(:integration_eparcerias_transfer_bank_order, contract: convenant)

      allow(Transparency::FollowerMailer).to receive(:citizen_following).and_call_original

      service = Transparency::Notifications::Integration::Contracts::ConvenantFollow.new(convenant.id)

      service.call
      convenant.reload && financial.reload && additive.reload && adjustment.reload && transfer_bank_order.reload

      expect(Transparency::FollowerMailer).to have_received(:citizen_following)

      expect(convenant.resource_status).to eq('resource_notified')
      expect(convenant.data_changes).to eq({})

      expect(financial.resource_status).to eq('resource_notified')
      expect(financial.data_changes).to eq({})

      expect(additive.resource_status).to eq('resource_notified')
      expect(additive.data_changes).to eq({})

      expect(adjustment.resource_status).to eq('resource_notified')
      expect(adjustment.data_changes).to eq({})

      expect(transfer_bank_order.resource_status).to eq('resource_notified')
      expect(transfer_bank_order.data_changes).to eq({})
    end

    it 'without changes' do
      additive = create(:integration_contracts_additive, contract: convenant)

      allow(Transparency::FollowerMailer).to receive(:citizen_following).and_call_original

      service = Transparency::Notifications::Integration::Contracts::ConvenantFollow.new(convenant.id)

      service.call
      convenant.reload && additive.reload

      expect(Transparency::FollowerMailer).to have_received(:citizen_following)
    end
  end
end
