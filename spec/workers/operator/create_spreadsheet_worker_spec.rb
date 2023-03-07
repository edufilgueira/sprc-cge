require 'rails_helper'
require 'sidekiq/testing'

describe Operator::CreateSpreadsheetWorker do

  describe 'background job' do
    describe 'when Operator::CreateSpreadsheet perform_async is called' do

      it 'calls Operator::CreateSpreadsheet call method' do
        export = create(:transparency_export, :user)
        expect do
          Operator::CreateSpreadsheetWorker.perform_async(export.id)
        end.to change(Operator::CreateSpreadsheetWorker.jobs, :size).by(1)
        expect(Sidekiq::Queues['exports']).not_to be_blank
      end
    end
  end
end
