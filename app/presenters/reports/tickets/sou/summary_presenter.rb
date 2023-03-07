class Reports::Tickets::Sou::SummaryPresenter < Reports::Tickets::BasePresenter

  def valid_count
    within_confirmed_at(scope).without_other_organs
      .without_internal_status(Ticket::INVALIDATED_STATUSES)
      .count
  end

  def relevant_to_executive_count
    valid_count
  end

  def invalidated_count
    within_confirmed_at(scope).with_internal_status(Ticket::INVALIDATED_STATUSES).count
  end

  def other_organs_count
    within_confirmed_at(scope).with_other_organs
      .without_internal_status(Ticket::INVALIDATED_STATUSES)
      .count
  end

  def total_count
    within_confirmed_at(scope).count
  end

  def reopened_count
    tickets = scope.without_other_organs.without_internal_status(Ticket::INVALIDATED_STATUSES)
    reopened_scope(tickets).count
  end

  def anonymous_count
    within_confirmed_at(scope).where(anonymous: true).count
  end

  def average_time_answer
    return 0 if responded_scope.blank?
    total_days_answer/responded_scope.count
  end

  def relevant_to_executive_count_str
    translate :relevant_to_executive_count
  end

  def invalidated_count_str
    translate :invalidated_count
  end

  def other_organs_count_str
    translate :other_organs_count
  end

  def total_count_str
    translate :total_count
  end

  def reopened_count_str
    translate :reopened_count
  end

  def anonymous_count_str
    translate :anonymous_count
  end

  def average_time_answer_str
    translate :average_time_answer
  end

  private

  def responded_scope
    @responded_scope ||=
      (default_responded_scope(within_confirmed_at(scope)) + default_responded_scope(tickets_log_scope(scope))).uniq
  end

  def default_responded_scope(tickets)
    tickets.where.not(responded_at: nil).without_other_organs.without_internal_status(Ticket::INVALIDATED_STATUSES)
  end

  def tickets_log_scope tickets
    tickets.joins(:ticket_logs).where(ticket_logs: { created_at: date_range })
  end

  def total_days_answer
    @total_days_answer ||= responded_scope.sum { |ticket|
      ticket.average_days_spent_to_answer date_range
    }
  end

  def translate(method_name)
    I18n.t("presenters.reports.tickets.sou.summary.#{method_name}", count: send(method_name))
  end

end
