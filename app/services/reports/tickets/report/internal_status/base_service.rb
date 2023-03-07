module Reports::Tickets::Report::InternalStatus::BaseService
  extend ActiveSupport::Concern

  included do

    private

    # Sobrescrever na classe
    def presenter
    end

    def build_sheet(sheet)
      add_header(sheet)

      presenter.rows.each { |row| xls_add_row(sheet, row) }

      xls_add_empty_rows(sheet)
      xls_add_row(sheet, presenter.total_row)
    end

    def sheet_type
      :internal_status
    end

    def add_header(sheet)
      xls_add_header(sheet, headers)
    end

    def headers
      presenter.class::COLUMNS.map do |column|
        I18n.t("services.reports.tickets.#{ticket_report.ticket_type_filter}.internal_status.headers.#{column}")
      end
    end
  end
end
