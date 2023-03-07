class Reports::Tickets::StatePresenter < Reports::Tickets::BasePresenter
  include ActionView::Helpers::NumberHelper

  COLUMNS = [
    :name,
    :count,
    :percentage
  ]

  def initialize(scope, ticket_report)
    @ticket_report = ticket_report
    @hash_scope = scope.left_joins(city: :state)
      .group('states.name')
      .order('states.name')

    @total = hash_total.values.sum

  end

  def rows
    hash_total.map { |state, count| row(state, count) }
  end

  def total_count
    @total
  end

  private

  def row(state, count)
    [ state || empty_state, count, percentage(count) ]
  end

  def empty_state
    I18n.t("services.reports.tickets.sou.state.empty")
  end
end
