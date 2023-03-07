class Reports::Tickets::Report::Sic::SolvabilityService < Reports::Tickets::Report::Sic::BaseService
  include ActionView::Helpers::NumberHelper

  private

  def presenter
    @presenter ||= Reports::Tickets::Sic::SolvabilityPresenter.new(report_scope, ticket_report)
  end

  def build_sheet(sheet)
    
    add_header(sheet)

    xls_add_empty_rows(sheet)

    xls_add_row(sheet, [
      I18n.t("#{t_base}.organ"),
      I18n.t("#{t_base}.solvability"),
      I18n.t("#{t_base}.total")
    ])

    total_count = 0 
    presenter.organs_solvability.each do |organ_solvability|
      xls_add_row(sheet, [
        organ_solvability[0],
        number_to_percentage(organ_solvability[1], precision: 2),
        organ_solvability[2]
      ])
      total_count += organ_solvability[2]
    end

    xls_add_empty_rows(sheet)
    xls_add_row(sheet, [I18n.t("#{t_base}.total_unscoped"),"" ,total_count] )
  end

  def sheet_type
    :solvability
  end

  def header_title
    I18n.t("#{t_base}.title")
  end

  def t_base
    "services.reports.tickets.sic.solvability"
  end
end
