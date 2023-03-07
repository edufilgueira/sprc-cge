require 'rails_helper'
require 'sidekiq/testing'

describe Transparency::CreateSpreadsheetWorker do

  describe 'background job' do
    describe 'when Transparency::CreateSpreadsheet perform_async is called' do

      it 'calls Transparency::CreateSpreadsheet call method' do
        export = create(:transparency_export, :server_salary)
        expect do
          Transparency::CreateSpreadsheetWorker.perform_async(export.id)
        end.to change(Transparency::CreateSpreadsheetWorker.jobs, :size).by(1)
        expect(Sidekiq::Queues['exports']).not_to be_blank
      end
    end
  end
end
