class TicketReport < ApplicationRecord
  include ::Reportable
  include Operator::Reports::TicketReports::Filters

  SIC_SHEETS = Reports::Tickets::Report::Sheets::SIC_SHEETS
  SOU_SHEETS = Reports::Tickets::Report::Sheets::SOU_SHEETS

  def sorted_tickets
    self.user.operator_accessible_tickets_for_report
  end

  def self.sic_sheet_name sheet
    sheet_name = sheet.to_s.split('::').last.underscore.gsub('_service', '')
    I18n.t("services.reports.tickets.sic.#{sheet_name}.sheet_name")
  end

  def self.sou_sheet_name sheet
    sheet_name = sheet.to_s.split('::').last.underscore.gsub('_service', '')
    I18n.t("services.reports.tickets.sou.#{sheet_name}.sheet_name")
  end
end
