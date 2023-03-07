module Reports::Tickets::Report::AnswerClassification::BaseService
  extend ActiveSupport::Concern

  included do

    private

    def presenter
      @presenter ||= Reports::Tickets::AnswerClassificationPresenter.new(default_scope, ticket_report)
    end

    def build_sheet(sheet)
      add_header(sheet)

      add_classifications(sheet)
    end

    def sheet_type
      :answer_classification
    end

    def add_classification(sheet, answer_classification)
      answer_classification_count = presenter.answer_classification_count(answer_classification)
      xls_add_row(sheet, [ presenter.answer_classification_str(answer_classification), answer_classification_count, presenter.answer_percentage(answer_classification_count) ])
    end

    def add_classifications(sheet)
      empty_label = I18n.t("services.reports.tickets.#{ticket_report.ticket_type_filter}.answer_classification.empty")
      without_classification_count = presenter.answer_classification_count(nil)
      xls_add_row(sheet, [ empty_label, without_classification_count, presenter.answer_percentage(without_classification_count)])

      add_classification(sheet, :legacy_classification)

      answer_classification_keys.each { |classification| add_classification(sheet, classification) }

      xls_add_empty_rows(sheet, 1)
      xls_add_row(sheet, [ I18n.t("services.reports.tickets.#{ticket_report.ticket_type_filter}.answer_classification.total"), presenter.total ])
    end

    def answer_classification_keys
      presenter.classification_keys - [nil, :legacy_classification]
    end
  end
end
