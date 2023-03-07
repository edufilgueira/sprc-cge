class Reports::Tickets::Report::Sic::GenderService < Reports::Tickets::Report::Sic::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::Sic::GenderPresenter.new(report_scope, ticket_report)
  end

  def add_header(sheet)
    xls_add_header(sheet, headers)
  end

  def headers
    presenter.class::COLUMNS.map do |column|
      I18n.t("services.reports.tickets.sic.gender.headers.#{column}")
    end
  end

  def build_sheet(sheet)
    add_header(sheet)

    genders_keys.each do |gender|
      xls_add_row(sheet, [ presenter.gender_str(gender), presenter.gender_count(gender), presenter.gender_percentage(gender) ])
    end
  end

  def sheet_type
    :gender
  end

  def genders_keys
    Ticket.genders.keys + [nil]
  end
end
