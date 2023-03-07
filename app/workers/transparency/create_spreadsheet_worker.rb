class Transparency::CreateSpreadsheetWorker
  include Sidekiq::Worker
  sidekiq_options queue: :exports

  def perform(transparency_export_id)
    Transparency::CreateSpreadsheet.call(transparency_export_id)
  end
end
