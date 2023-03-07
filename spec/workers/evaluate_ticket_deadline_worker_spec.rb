require 'rails_helper'
require 'sidekiq/testing'

describe EvaluateTicketDeadlineWorker do

  describe 'background job' do
    describe 'when EvaluateTicketDeadline perform_async is called' do
      it 'calls EvaluateTicketDeadline call method' do
        expect do
          EvaluateTicketDeadlineWorker.perform_async
          EvaluateTicketDeadlineWorker.drain
        end.to change(Sidekiq::Extensions::DelayedClass.jobs, :size).by(1)
      end

    end
  end
end
