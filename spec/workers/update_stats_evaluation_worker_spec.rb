require 'rails_helper'
require 'sidekiq/testing'

describe UpdateStatsEvaluationWorker do

  describe 'background job' do
    describe 'when UpdateStatsEvaluationWorker perform_async is called' do

      it 'date present' do
        expect do
          UpdateStatsEvaluationWorker.perform_async
        end.to change(UpdateStatsEvaluationWorker.jobs, :size).by(1)
        expect(Sidekiq::Queues['low'].size).to_not be_blank
      end
    end
  end
end
