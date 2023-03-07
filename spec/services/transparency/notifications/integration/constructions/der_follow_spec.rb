require 'rails_helper'

describe Transparency::Notifications::Integration::Constructions::DerFollow do

  let(:der) { create(:integration_constructions_der) }
  let!(:follower) { create(:transparency_follower, resourceable: der) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      allow(Transparency::Notifications::Integration::Constructions::DerFollow).to receive(:call)
      Transparency::Notifications::Integration::Constructions::DerFollow.call(der.id)

      expect(Transparency::Notifications::Integration::Constructions::DerFollow).to have_received(:call).with(der.id)
    end
  end

  describe 'initialization' do
    it 'responds to notification' do
      service = Transparency::Notifications::Integration::Constructions::DerFollow.new(der.id)

      expect(service.der).to be_an_instance_of(Integration::Constructions::Der)
    end
  end

  describe 'call' do
    it 'create_email' do
      der.update(percentual_executado: 51, data_fim_previsto: Date.tomorrow)
      measurement = create(:integration_constructions_der_measurement, integration_constructions_der: der)

      allow(Transparency::FollowerMailer).to receive(:citizen_following).and_call_original

      service = Transparency::Notifications::Integration::Constructions::DerFollow.new(der.id)

      service.call
      der.reload && measurement.reload

      expect(Transparency::FollowerMailer).to have_received(:citizen_following)
      expect(der.resource_status).to eq('resource_notified')
      expect(der.data_changes).to eq({})
      expect(measurement.resource_status).to eq('resource_notified')
      expect(measurement.data_changes).to eq({})
    end

    it 'without changes' do
      measurement = create(:integration_constructions_der_measurement, integration_constructions_der: der)

      allow(Transparency::FollowerMailer).to receive(:citizen_following).and_call_original

      service = Transparency::Notifications::Integration::Constructions::DerFollow.new(der.id)

      service.call
      der.reload && measurement.reload

      expect(Transparency::FollowerMailer).to have_received(:citizen_following)
    end
  end
end
