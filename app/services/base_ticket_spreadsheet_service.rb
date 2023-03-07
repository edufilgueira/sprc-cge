##
# Métodos compartilhados pelos geradores de planilhas
#
##

class BaseTicketSpreadsheetService < BaseSpreadsheetService
  include ReportsHelper

  ASSOCIATIONS_FILTERS = {
    organ: Organ
  }

  SIMPLES_FILTERS = [
    'ticket_type',
    'expired'
  ]

  RANGES_FILTERS = [
    'confirmed_at'
  ]

  private

  ## spreadsheet_object (gross_export, ticket_report, ...)

  def set_progress(processed, total_to_process=nil)
    attrs = {
      processed: processed
    }

    attrs[:total_to_process] = total_to_process if total_to_process.present?

    spreadsheet_object.update_attributes(attrs)
  end

  def set_status(status)
    spreadsheet_object.update_attribute(:status, status)
  end

  def set_total(total)
    spreadsheet_object.update_attribute(:total, total)
  end

  def tickets
    spreadsheet_object.filtered_scope.without_characteristic
  end

  def tickets_invalidated
    Ticket.where(ticket_type: ticket_type).invalidated
  end

  def tickets_invalidated_and_other_organs
    tickets_invalidated.with_other_organs
  end

  def ticket_type
    spreadsheet_object.filters[:ticket_type]
  end

  def finish_spreadsheet
    if super
      set_status(:success)
    else
      set_status(:error)
    end
  end

  ## Sumário compartilhado por report e export

  def generate_sheet_summary(sheet)
    title = "#{I18n.t('app.title')} / #{I18n.t('app.author')}"

    xls_add_header(sheet, [ title ])

    summary_add_infos(sheet)
    summary_add_filters(sheet)
  end

  def summary_add_infos(sheet)
    summary_add_infos_title(sheet)
    summary_add_infos_object_title(sheet)
    summary_add_infos_object_creator(sheet)
    summary_add_infos_count(sheet)
  end

  def summary_add_infos_title(sheet)
    xls_add_empty_rows(sheet, 2)

    infos_title = I18n.t("#{spreadsheet_object_symbol}.spreadsheet.worksheets.summary.infos.title")

    xls_add_header(sheet, [ infos_title ])
  end

  def summary_add_infos_object_title(sheet)
    spreadsheet_object_title = I18n.t("#{spreadsheet_object_symbol}.spreadsheet.worksheets.summary.infos.ticket_report_title", value: spreadsheet_object.title)
    xls_add_row(sheet, [ spreadsheet_object_title ])
  end

  def summary_add_infos_object_creator(sheet)
    summary_add_created_by(sheet)
    summary_add_created_at(sheet)
    summary_add_creator_email(sheet)
    summary_add_organ(sheet) if spreadsheet_object.user.organ.present?
    summary_add_operator_type(sheet) if spreadsheet_object.user.operator?
  end

  def summary_add_created_by(sheet)
    created_by = I18n.t("#{spreadsheet_object_symbol}.spreadsheet.worksheets.summary.infos.created_by", value: spreadsheet_object.user.name)
    xls_add_row(sheet, [ created_by ])
  end

  def summary_add_created_at(sheet)
    created_at = I18n.t("#{spreadsheet_object_symbol}.spreadsheet.worksheets.summary.infos.created_at", value: I18n.l(spreadsheet_object.created_at, format: :long))
    xls_add_row(sheet, [ created_at ])
  end

  def summary_add_creator_email(sheet)
    email = I18n.t("#{spreadsheet_object_symbol}.spreadsheet.worksheets.summary.infos.email", value: spreadsheet_object.user.email)
    xls_add_row(sheet, [ email ])
  end

  def summary_add_organ(sheet)
    organ = I18n.t("#{spreadsheet_object_symbol}.spreadsheet.worksheets.summary.infos.organ", value: spreadsheet_object.user.organ_acronym)
    xls_add_row(sheet, [ organ ])
  end

  def summary_add_operator_type(sheet)
    operator_type = I18n.t("#{spreadsheet_object_symbol}.spreadsheet.worksheets.summary.infos.operator_type", value: spreadsheet_object.user.operator_type_str)
    xls_add_row(sheet, [ operator_type ])
  end

  def summary_add_infos_count(sheet)
    xls_add_row(sheet, [ tickets_count_row ])
    xls_add_row(sheet, [ invalidated_count_row ])
    xls_add_row(sheet, [ invalidated_and_other_organs_count_row ])
    xls_add_row(sheet, [ reopened_count_row ])
  end

  def tickets_count_row
    count = tickets.count
    I18n.t("#{spreadsheet_object_symbol}.spreadsheet.worksheets.summary.infos.tickets_count", value: count)
  end

  def invalidated_count_row
    count = tickets_invalidated.count
    I18n.t("#{spreadsheet_object_symbol}.spreadsheet.worksheets.summary.infos.invalidated_count", value: count)
  end

  def invalidated_and_other_organs_count_row
    count = tickets_invalidated_and_other_organs.count
    I18n.t("#{spreadsheet_object_symbol}.spreadsheet.worksheets.summary.infos.invalidated_and_other_organs", value: count)
  end

  def reopened_count_row
    count = reopened_tickets.count
    I18n.t("#{spreadsheet_object_symbol}.spreadsheet.worksheets.summary.infos.#{reopened_method_name}", value: count)
  end

  def reopened_tickets
    Ticket.send(reopened_method_name, filter_confirmed_at_start, filter_confirmed_at_end)
  end

  def filter_confirmed_at_start
    filter_confirmed_at[:start] if filter_confirmed_at.present?
  end

  def filter_confirmed_at_end
    filter_confirmed_at[:end] if filter_confirmed_at.present?
  end

  def filter_confirmed_at
    spreadsheet_object.filters[:confirmed_at]
  end

  def reopened_method_name
    ticket_type == 'sou' ? 'reopened_at' : 'appealed_at'
  end

  def summary_add_filters(sheet)
    summary_add_filters_title(sheet)

    unless has_filters?
      xls_add_row(sheet, [ I18n.t("#{spreadsheet_object_symbol}.spreadsheet.worksheets.summary.filters.none") ])
    else
      summary_filter_keys.each do |filter_key|
        filter_value = spreadsheet_object.filters[filter_key]
        summary_add_filter_value(sheet, filter_key, filter_value)
      end
    end
  end

  def has_filters?
    filters = spreadsheet_object.filters
    filter_values = (filters && filters.values) || []
    filter_values.reject(&:blank?).any?
  end

  def summary_filter_keys
    filters = spreadsheet_object.filters
    (filters && filters.keys) || []
  end

  def summary_add_filter_value(sheet, filter_key, filter_value)
    if filter_value.present?
      filter_label = I18n.t("report.filters.#{filter_key}")
      filter_final_value = report_filter_value(filter_key, filter_value)

      cell_text = "#{filter_label}: #{filter_final_value}"
      xls_add_row(sheet, [ cell_text ])
    end
  end

  def summary_add_filters_title(sheet)
    xls_add_empty_rows(sheet, 2)

    filters_title = I18n.t("#{spreadsheet_object_symbol}.spreadsheet.worksheets.summary.filters.title")
    xls_add_header(sheet, [ filters_title ])
  end
end
