##
# Remove planilha de chamados. É chamado antes do destroy de um TicketReport.
#
##

class RemoveTicketReportSpreadsheet

  # Attributes

  attr_reader :ticket_report

  def initialize(ticket_report)
    @ticket_report = ticket_report
  end

  def call
    remove_dir
  end

  def self.call(ticket_report)
    new(ticket_report).call
  end

  private

  def remove_dir
    FileUtils.rm_rf(ticket_report_dir_path) if File.exist?(ticket_report_dir_path)
  end

  def ticket_report_dir_path
    ticket_report.dir_path
  end
end
