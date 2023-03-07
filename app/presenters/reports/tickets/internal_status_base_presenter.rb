class Reports::Tickets::InternalStatusBasePresenter < Reports::Tickets::BasePresenter
  include ActionView::Helpers::NumberHelper

  attr_reader :hash_count

  COLUMNS = [
    :internal_status,
    :count,
    :percentage
  ]

  def initialize(scope, ticket_report)
    @scope = scope
    @ticket_report = ticket_report
    @hash_count = reopened_in_range(within_confirmed_at(scope)).group('tickets.internal_status').count
    @total = within_confirmed_at(scope).count + reopened_count(scope)
  end

  def rows
    internal_statuses.map { |internal_status| row(internal_status) }
  end

  def total_row
    [ I18n.t("services.reports.tickets.#{ticket_report.ticket_type_filter}.internal_status.total"), total ]
  end

  private

  def row(internal_status)
    count = hash_total[internal_status] || 0.0
    [ internal_status_str(internal_status), count, percentage(count) ]
  end

  def internal_status_str(internal_status)
    I18n.t("ticket.internal_statuses.#{internal_status}")
  end

  def internal_statuses
    Ticket.internal_statuses.except(:appeal).keys
  end

  def final_answer_reopened
    reopened_scope(scope).count + reopened_out_range(within_confirmed_at(scope)).count
  end

  def hash_total
    @hash_total ||= hash_count.merge({
      'final_answer' => final_answer_reopened
      }) { |_, a, b| a + b }
  end
end
