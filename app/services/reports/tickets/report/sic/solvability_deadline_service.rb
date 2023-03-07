class Reports::Tickets::Report::Sic::SolvabilityDeadlineService < Reports::Tickets::Report::Sic::BaseService
  include ActionView::Helpers::NumberHelper

  private

  def presenter
    @presenter ||= Reports::Tickets::Sic::SolvabilityDeadlinePresenter.new(default_scope, ticket_report)
  end

  def build_sheet(sheet)
    add_header(sheet)

    infos = presenter.call

    xls_add_empty_rows(sheet)
    xls_add_row(sheet, [
      I18n.t("services.reports.tickets.sic.solvability_deadline.organ"),
      I18n.t("services.reports.tickets.sic.solvability_deadline.type"),
      I18n.t("services.reports.tickets.sic.solvability_deadline.call_center_csai"),
      I18n.t("services.reports.tickets.sic.solvability_deadline.call_center"),
      I18n.t("services.reports.tickets.sic.solvability_deadline.csai")
    ])

    build_info(sheet, infos)
  end

  def build_info(sheet, infos)
    types = [ 'until_20', 'between_21_30.with_deadline', 'between_21_30.without_deadline', 'more_than_30']

    infos[:call_center_csai].each_with_index do |call_center_csai, index|
      types.each_with_index do |type, index_type|
        xls_add_row(sheet, [
          call_center_csai[0],
          I18n.t("services.reports.tickets.sic.solvability_deadline.types.#{type}"),
          call_center_csai[index_type+1],
          infos[:call_center][index][index_type+1],
          infos[:csai][index][index_type+1]
        ])
      end

      xls_add_empty_rows(sheet)
    end
  end

  def sheet_type
    :solvability_deadline
  end

  def header_title
    I18n.t("services.reports.tickets.sic.solvability_deadline.title")
  end
end
