class Reports::Tickets::Report::Sou::GenderService < Reports::Tickets::Report::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::Sou::GenderPresenter.new(default_scope, ticket_report)
  end

  def add_header(sheet)
    xls_add_header(sheet, headers)
  end

  def headers
    presenter.class::COLUMNS.map do |column|
      I18n.t("services.reports.tickets.sou.gender.headers.#{column}")
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
