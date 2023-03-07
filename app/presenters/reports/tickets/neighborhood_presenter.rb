class Reports::Tickets::NeighborhoodPresenter < Reports::Tickets::BasePresenter
  include ActionView::Helpers::NumberHelper

  COLUMNS = [
    :name,
    :count,
    :percentage
  ]

  def initialize(scope, ticket_report)
    @ticket_report = ticket_report
    @hash_scope = scope
      .group('tickets.target_address_neighborhood')
      .order('tickets.target_address_neighborhood')

    @total = hash_total.values.sum
  end

  def rows
    hash_total.map { |neighborhood, count| row(neighborhood, count) }
  end

  def total_count
    @total
  end

  private

  def row(neighborhood, count)
    [ neighborhood || empty_neighborhood, count, percentage(count) ]
  end

  def empty_neighborhood
    I18n.t("services.reports.tickets.sou.neighborhood.empty")
  end
end
