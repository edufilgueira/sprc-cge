class Reports::Tickets::Sou::ReopenedPresenter
  include ActionView::Helpers::NumberHelper

  attr_reader :scope

  COLUMNS = [
    :protocol,
    :organ,
    :count
  ]

  def initialize(scope)
    @scope = scope
  end

  def rows(date_range)
    hash_count(date_range).map { |data, count| row(data, count) }
  end

  private

  def row(data, count)
    [ data[0], data[1], count ]
  end

  def hash_count(date_range)
    @hash_count ||= scope.joins(:ticket_logs)
      .left_joins(:organ)
      .where(ticket_logs: {
        action: TicketLog.actions[:reopen],
        created_at: date_range
      })
      .group('tickets.parent_protocol', 'organs.acronym')
      .order('tickets.parent_protocol', 'organs.acronym')
      .count
  end

  def total(date_range)
    @total ||= hash_count(date_range).values.sum
  end
end
