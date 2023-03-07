module Reports::Tickets::Report::Topic::BaseService
  extend ActiveSupport::Concern

  included do

    private

    def presenter
      @presenter ||= Reports::Tickets::TopicPresenter.new(default_scope, ticket_report)
    end

    def build_sheet(sheet)
      add_header(sheet)
      presenter.rows.each { |row| xls_add_row(sheet, row) }
    end

    def sheet_type
      :topic
    end

    def add_header(sheet)
      xls_add_header(sheet, headers)
    end

    def headers
      row = [ topic_title, organ_title, count_title, percentage_title ]
      row -= [organ_title] unless include_organ?

      row
    end

    def topic_title
      I18n.t("services.reports.tickets.#{ticket_report.ticket_type_filter}.#{sheet_type}.title")
    end

    def organ_title
      I18n.t("services.reports.tickets.#{ticket_report.ticket_type_filter}.#{sheet_type}.organ.title")
    end

    def count_title
      I18n.t("services.reports.tickets.#{ticket_report.ticket_type_filter}.#{sheet_type}.count.title")
    end

    def percentage_title
      I18n.t("services.reports.tickets.#{ticket_report.ticket_type_filter}.#{sheet_type}.percentage.title")
    end
  end
end
