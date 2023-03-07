class Reports::Attendances::BaseService < BaseSpreadsheetService

  attr_reader :xls_workbook, :beginning_date, :end_date

  def self.call(xls_workbook, beginning_date, end_date)
    new(xls_workbook, beginning_date, end_date).call
  end

  def initialize(xls_workbook, beginning_date, end_date)
    @xls_workbook = xls_workbook
    @beginning_date = beginning_date
    @end_date = end_date
  end

  def call
    generate_spreadsheet
  end

  private

  def build_sheet(sheet)
    add_attendance_header(sheet)
    add_attendance_table(sheet)

    xls_add_empty_rows(sheet, 1)

    add_returned_phone_header(sheet)
    add_returned_phone_table(sheet)

    xls_add_empty_rows(sheet, 1)

    add_returned_whatsapp_header(sheet)
    add_returned_whatsapp_table(sheet)
  end

  #
  # Implementar na classe que estender
  #
  def sheet_type
  end

  def default_scope
    @default_scope ||= Attendance.joins(:ticket).where(created_at: date_range)
  end

  def generate_spreadsheet
    worksheet_title = sanitized_worksheet_title(sheet_type)

    xls_workbook.add_worksheet(name: worksheet_title) do |sheet|
      xls_add_empty_rows(sheet, 2)
      build_sheet(sheet)
    end
  end

  def date_range
    beginning_date..end_date.end_of_day
  end

  def worksheet_title(worksheet_type)
    I18n.t("services.reports.attendances.#{worksheet_type}.sheet_name")
  end

  def add_header(sheet)
    xls_add_header(sheet, [ header_title ])
  end

  def add_attendance_header(sheet)
    xls_add_header(sheet, [ attendance_header_title ])
  end

  def add_attendance_table(sheet)
    total_attendance = 0

    users.each do | user|
      count = attendances_by_user_presenter.count(user)
      next if count.zero?
      total_attendance += count
      xls_add_row(sheet, [ user.name, count ])
    end

    xls_add_header(sheet, [ '', total_attendance ])
  end

  def add_returned_phone_header(sheet)
    xls_add_header(sheet, [
      returned_phone_header_title,
      returned_phone_header_with_success_title,
      returned_phone_header_without_success_title,
      returned_phone_header_attemps_title,
      returned_phone_header_total_protocols_title
    ])
  end

  def add_returned_phone_table(sheet)
    total_returned_phone_with_success = 0
    total_returned_phone_without_success = 0
    total_returned_attemps = 0
    total_returned_phone_by_ticket = 0

    users.each do |user|
      returned_with_success_count = phone_returned_by_user_presenter.count_with_success(user)
      returned_without_success_count = phone_returned_by_user_presenter.count_without_success(user)
      returned_by_tickets_count = phone_returned_by_user_presenter.count_by_ticket(user)

      total_returned_phone_with_success += returned_with_success_count
      total_returned_phone_without_success += returned_without_success_count
      total_returned_phone_by_ticket += returned_by_tickets_count

      returned_attempts = returned_with_success_count + returned_without_success_count
      total_returned_attemps += returned_attempts
      xls_add_row(sheet, [user.name, returned_with_success_count, returned_without_success_count, returned_attempts, returned_by_tickets_count])
    end

    xls_add_header(sheet, [ '', total_returned_phone_with_success, total_returned_phone_without_success, total_returned_attemps, total_returned_phone_by_ticket ])
  end

  def add_returned_whatsapp_header(sheet)
    xls_add_header(sheet, [ returned_whatsapp_header_title, returned_whatsapp_header_total_returned_title ])
  end

  def add_returned_whatsapp_table(sheet)
    total_returned_whatsapp = 0

    users.each do |user|
      returned_count = whatsapp_returned_by_user_presenter.count(user)

      total_returned_whatsapp += returned_count
      xls_add_row(sheet, [user.name, returned_count])
    end

    xls_add_header(sheet, ['', total_returned_whatsapp])
  end

  def header_title
    I18n.t("services.reports.attendances.#{sheet_type}.title")
  end

  def attendance_header_title
    I18n.t("services.reports.attendances.#{sheet_type}.attendance_title")
  end

  def returned_phone_header_title
    I18n.t("services.reports.attendances.#{sheet_type}.returned_phone_title")
  end

  def returned_phone_header_with_success_title
    I18n.t("services.reports.attendances.#{sheet_type}.returned_phone_header_with_success_title")
  end

  def returned_phone_header_without_success_title
    I18n.t("services.reports.attendances.#{sheet_type}.returned_phone_header_without_success_title")
  end

  def returned_phone_header_attemps_title
    I18n.t("services.reports.attendances.#{sheet_type}.returned_phone_header_attemps_title")
  end

  def returned_phone_header_total_protocols_title
    I18n.t("services.reports.attendances.#{sheet_type}.returned_phone_header_total_protocols_title")
  end

  def returned_whatsapp_header_title
    I18n.t("services.reports.attendances.#{sheet_type}.returned_whatsapp_title")
  end

  def returned_whatsapp_header_total_returned_title
    I18n.t("services.reports.attendances.#{sheet_type}.returned_whatsapp_header_total_returned_title")
  end

  def users
    User.enabled.where(operator_type: [:call_center, :call_center_supervisor]).order(:name)
  end

  def attendance_response_scope
    TicketLog.joins(:ticket)
      .joins('JOIN attendance_responses ON attendance_responses.id = ticket_logs.resource_id')
      .where(tickets: { ticket_type: sheet_type }, ticket_logs: { responsible_type: 'User', resource_type: 'AttendanceResponse', created_at: date_range })
  end
end
