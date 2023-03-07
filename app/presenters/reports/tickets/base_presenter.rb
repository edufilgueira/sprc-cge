class Reports::Tickets::BasePresenter
  attr_reader :scope, :total, :ticket_report, :hash_scope

  def initialize(scope, ticket_report)
    @scope = scope
    @ticket_report = ticket_report
  end

  protected

  def beginning_date
    return Date.new(0) unless date_filter.present?
    date_filter[:start].to_date
  end

  def end_date
    return Date.today.end_of_day unless date_filter.present?
    date_filter[:end].to_date.end_of_day
  end

  def date_range
    beginning_date..end_date
  end

  def reopened_count(tickets)
    reopened_scope(tickets).count
  end

  def reopened_scope(tickets)
    tickets.joins(:ticket_logs)
      .where(ticket_logs: { action: [:pseudo_reopen, :reopen], created_at: date_range })
  end

  def user
    ticket_report.user
  end

  def percentage(count)
    number_to_percentage(count.to_f * 100 / total, precision: 2)
  end

  def include_organ?
    user.cge? || user.call_center_operator?
  end

  def hash_with_reopened
    within_confirmed_at(hash_scope).count.merge(reopened_count(hash_scope)) { |_, a, b| a + b }
  end

  def hash_total
    @hash_total ||= hash_with_reopened
  end

  def within_confirmed_at(tickets)
    tickets.where(tickets: { confirmed_at: date_range, pseudo_reopen: false })
  end

  def sort_and_limit_hash(hash, limit=14)
    Hash[hash.sort_by{ |k, v| v }.reverse[0..limit]]
  end

  def reopened_out_range(tickets)
    tickets.where('tickets.reopened_at > ?', end_date)
  end

  def reopened_in_range(tickets)
    tickets.where('tickets.reopened_at IS NULL OR tickets.reopened_at <= ?', end_date)
  end

  def date_filter
    ticket_report.filters[:confirmed_at]
  end
end
