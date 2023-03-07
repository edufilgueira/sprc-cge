class Reports::Tickets::Report::Sou::SouTypeByTopicService < Reports::Tickets::Report::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::Sou::SouTypeByTopicPresenter.new(default_scope, ticket_report)
  end

  def build_sheet(sheet)
    add_header(sheet)

    presenter.rows.each { |row| xls_add_row(sheet, row) }
  end

  def sheet_type
    :sou_type_by_topic
  end

  def add_header(sheet)
    xls_add_header(sheet, headers)
  end

  def headers
    presenter.class::COLUMNS.map do |column|
      I18n.t("services.reports.tickets.sou.sou_type_by_topic.headers.#{column}")
    end
  end
end
