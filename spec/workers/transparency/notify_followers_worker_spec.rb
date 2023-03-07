require 'rails_helper'
require 'sidekiq/testing'

describe Transparency::NotifyFollowersWorker do

  describe 'background job' do
    describe 'when Transparency::NotifyFollowersWorker perform_async is called' do

      it 'calls Transparency::NotifyFollowersWorker call method' do
        dae = create(:integration_constructions_dae)
        der = create(:integration_constructions_der)
        create(:transparency_follower, resourceable: dae)
        create(:transparency_follower, resourceable: der)

        expect do
          Transparency::NotifyFollowersWorker.perform_async
        end.to change(Transparency::NotifyFollowersWorker.jobs, :size).by(1)

        expect(Sidekiq::Queues['low']).not_to be_blank
      end
    end
  end
end
