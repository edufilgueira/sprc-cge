require 'rails_helper'

describe Transparency::Notifications::Integration::Constructions::DaeFollow do

  let(:dae) { create(:integration_constructions_dae) }
  let!(:follower) { create(:transparency_follower, resourceable: dae) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      allow(Transparency::Notifications::Integration::Constructions::DaeFollow).to receive(:call)
      Transparency::Notifications::Integration::Constructions::DaeFollow.call(dae.id)

      expect(Transparency::Notifications::Integration::Constructions::DaeFollow).to have_received(:call).with(dae.id)
    end
  end

  describe 'initialization' do
    it 'responds to notification' do
      service = Transparency::Notifications::Integration::Constructions::DaeFollow.new(dae.id)

      expect(service.dae).to be_an_instance_of(Integration::Constructions::Dae)
    end
  end

  describe 'call' do
    it 'create_email' do
      dae.update(percentual_executado: 51, data_fim_previsto: Date.tomorrow)
      photo = create(:integration_constructions_dae_photo, integration_constructions_dae: dae)
      measurement = create(:integration_constructions_dae_measurement, integration_constructions_dae: dae)

      allow(Transparency::FollowerMailer).to receive(:citizen_following).and_call_original

      service = Transparency::Notifications::Integration::Constructions::DaeFollow.new(dae.id)

      service.call
      dae.reload && photo.reload && measurement.reload

      expect(Transparency::FollowerMailer).to have_received(:citizen_following)
      expect(dae.resource_status).to eq('resource_notified')
      expect(dae.data_changes).to eq({})
      expect(photo.resource_status).to eq('resource_notified')
      expect(photo.data_changes).to eq({})
      expect(measurement.resource_status).to eq('resource_notified')
      expect(measurement.data_changes).to eq({})
    end
  end

  it 'without changes' do
    photo = create(:integration_constructions_dae_photo, integration_constructions_dae: dae)

    allow(Transparency::FollowerMailer).to receive(:citizen_following).and_call_original

    service = Transparency::Notifications::Integration::Constructions::DaeFollow.new(dae.id)

    service.call
    dae.reload && photo.reload

    expect(Transparency::FollowerMailer).to have_received(:citizen_following)
  end
end
