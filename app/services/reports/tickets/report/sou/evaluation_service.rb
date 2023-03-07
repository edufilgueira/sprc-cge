class Reports::Tickets::Report::Sou::EvaluationService < Reports::Tickets::Report::BaseService
  include Reports::Tickets::Report::Evaluation::BaseService

  def build_sheet(sheet)
    add_header(sheet)
    xls_add_row(sheet, [])

    add_basic_questions(sheet)
    xls_add_row(sheet, [])
    
    add_expectation(sheet)
    xls_add_row(sheet, [])

    resolubility(sheet)
    xls_add_row(sheet, [])

    xls_add_row(sheet, [])
    add_total_of_resolubility(sheet)
  end
  
  private

  def add_header(sheet)
    xls_add_header(sheet, [ header_title, " " ])
  end

  def header_title
    type = ticket_report.ticket_type_filter.upcase.to_s
    date_ini = beginning_date.to_s
    date_fin = end_date.to_s
    I18n.t("#{t_base}.title", type: type, begin: date_ini, end: date_fin)
  end

  def ticket_report_type
    ticket_report[:filters][:ticket_type]
  end
end
