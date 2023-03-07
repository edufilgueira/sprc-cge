require 'rails_helper'

describe RemoveReportableSpreadsheet do
  let(:date) { Date.today }

  context 'ticket_report' do
    let(:ticket_report) { create(:ticket_report) }

    let(:create_ticket_report_spreadsheet) { CreateTicketReportSpreadsheet.new(ticket_report.id) }

    subject(:remove_ticket_report_spreadsheet) { RemoveReportableSpreadsheet.new(ticket_report) }

    it 'removes base ticket_report dir' do
      # cria para testarmos a remoção
      create_ticket_report_spreadsheet.call

      dir = Rails.root.join('public', 'files', 'downloads', 'ticket_report', ticket_report.id.to_s)

      expect(File.exist?(dir)).to eq(true)

      subject.call
      expect(File.exist?(dir)).to eq(false)
    end
  end

  context 'gross_export' do
    let(:gross_export) { create(:gross_export, filters: { ticket_type: :sou, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month} }) }

    let(:create_gross_export_spreadsheet) { CreateGrossExportSpreadsheet.new(gross_export.id) }

    subject(:remove_gross_export_spreadsheet) { RemoveReportableSpreadsheet.new(gross_export) }

    it 'removes base gross_export dir' do
      # cria para testarmos a remoção
      create_gross_export_spreadsheet.call

      dir = Rails.root.join('public', 'files', 'downloads', 'gross_export', gross_export.id.to_s)

      expect(File.exist?(dir)).to eq(true)

      subject.call
      expect(File.exist?(dir)).to eq(false)
    end
  end
end
