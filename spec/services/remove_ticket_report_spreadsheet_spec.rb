require 'rails_helper'

describe RemoveTicketReportSpreadsheet do

  let(:ticket_report) { create(:ticket_report) }

  let(:create_ticket_report_spreadsheet) { CreateTicketReportSpreadsheet.new(ticket_report.id) }

  subject(:remove_ticket_report_spreadsheet) { RemoveTicketReportSpreadsheet.new(ticket_report) }

  it 'removes base ticket_report dir' do
    # cria para testarmos a remoção
    create_ticket_report_spreadsheet.call

    dir = Rails.root.join('public', 'files', 'downloads', 'ticket_report', ticket_report.id.to_s)

    expect(File.exist?(dir)).to eq(true)

    subject.call
    expect(File.exist?(dir)).to eq(false)
  end
end
