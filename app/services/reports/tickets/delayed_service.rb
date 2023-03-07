class Reports::Tickets::DelayedService < Reports::BaseService

  SHEETS = [
    Reports::Tickets::Delayed::SicService,
    Reports::Tickets::Delayed::SouService
  ]

  private

  def spreadsheet_dir_path
    Rails.root.join('public', 'files', 'downloads', 'reports', 'delayed')
  end

  def filename
    "delayed_#{Time.now.to_i}.xlsx"
  end
end
