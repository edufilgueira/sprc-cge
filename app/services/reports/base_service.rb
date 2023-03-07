class Reports::BaseService < BaseSpreadsheetService

  attr_reader :beginning_date, :end_date

  SHEETS = []

  def self.call(beginning_date, end_date)
    new(beginning_date, end_date).call
  end

  def initialize(beginning_date, end_date)
    @beginning_date = beginning_date
    @end_date = end_date

    create_dir
  end

  def call
    generate_spreadsheet
    finish_spreadsheet
  end

  private

  def generate_spreadsheet
    self.class::SHEETS.each do |sheet|
      sheet.call(xls_workbook, beginning_date, end_date)
    end
  end

  def spreadsheet_file_path
    "#{spreadsheet_dir_path}/#{filename}"
  end

  def filename
    "report_#{Time.now.to_i}.xlsx"
  end
end
