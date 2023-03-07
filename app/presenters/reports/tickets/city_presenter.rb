class Reports::Tickets::CityPresenter < Reports::Tickets::BasePresenter
  include ActionView::Helpers::NumberHelper

  COLUMNS = [
    :name,
    :count,
    :percentage
  ]

  def initialize(scope, ticket_report)
    @ticket_report = ticket_report
    @hash_scope = scope.left_joins(:city)
      .group('cities.name')
      .order('cities.name')

    @total = hash_total.values.sum
  end

  def rows
    hash_total.map { |city, count| row(city, count) }
  end

  def total_count
    @total
  end

  private

  def row(city, count)
    [ city || empty_city, count, percentage(count) ]
  end

  def empty_city
    I18n.t("services.reports.tickets.sou.city.empty")
  end
end
