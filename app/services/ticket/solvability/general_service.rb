class Ticket::Solvability::GeneralService
  include ::Reports::Tickets::ScopePresenter

  attr_accessor :answer_scope, :scope, :start_date, :end_date

  def self.call(scope, organ = nil, start_date = nil, end_date = nil)
    new(scope, organ, start_date, end_date).call
  end

  def initialize(scope, organ = nil, start_date = nil, end_date = nil)
    @scope = scope
    @scope = @scope.joins(:organ).where(organs: { id: organ }) if organ.present?

    @answer_scope = @scope.joins(:answers).group('tickets.id', 'answers.version')

    @start_date = (start_date || DateTime.new(0)).beginning_of_day
    @end_date = (end_date || DateTime.now).end_of_day
  end

  def call
    calculate_solvability
  end

  def resolubility
    @resolubility ||= calculate_solvability
  end

  def total_count
    @total_count ||= confirmed_and_not_expired_count + confirmed_and_expired_count + replied_and_not_expired_count + replied_and_expired_count
  end

  # Total de Manifestações pendentes no prazo !!!!!!!!!!!!!!!!!!!!!
  def confirmed_and_not_expired_count
    @confirmed_and_not_expired_count ||= not_expired_scope(confirmed_scope).count
  end

  # Total de Manifestações pendentes fora do prazo
  def confirmed_and_expired_count
    @confirmed_and_expired_count ||= expired_scope(confirmed_scope).count
  end

  # Total de Manifestações pendentes
  def confirmed_scope
    visible_to_user_statuses_values = Answer::VISIBLE_TO_USER_STATUSES.map { |key| Answer.statuses[key] }.join(', ')
    position_scopes_values = Answer::POSITIONING_SCOPES.map { |key| Answer.answer_scopes[key] }.join(', ')

    @confirmed_scope ||= scope.active.joins(
      "LEFT JOIN answers ON answers.ticket_id = tickets.id
        AND answers.version = tickets.reopened
        AND answers.deleted_at IS NULL
        AND answers.status IN (#{visible_to_user_statuses_values})
        AND answers.answer_scope NOT IN (#{position_scopes_values})"
    )
    .where(answers: { ticket_id: nil } )
    .where('tickets.reopened_at IS NULL OR tickets.reopened_at BETWEEN ? AND ?', start_date, end_date)
    .where('tickets.reopened_at IS NOT NULL OR tickets.confirmed_at BETWEEN ? AND ?', start_date, end_date)
  end

  # Total de Manifestações finalizadas no prazo
  def replied_and_not_expired_count
    @replied_and_not_expired_count ||= ticket_replied_not_expired.count.count + reopen_replied_not_expired.count.count
  end

  # Total de Manifestações finalizadas no prazo SEM REABERTURA
  def ticket_replied_not_expired
    replied_and_not_expired_scope(not_reopened_scope(within_confirmed_at(answer_scope)))
  end

  # Total de Manifestações finalizadas no prazo COM REABERTURA
  def reopen_replied_not_expired
    join_ticket_log_reopen_and_answer(
      replied_and_not_expired_scope(answer_reopened_scope(answer_scope))
    )
  end

  # Total de Manifestações finalizadas fora do prazo
  def replied_and_expired_count
    @replied_and_expired_count ||= ticket_replied_expired.count.count + reopen_replied_expired.count.count
  end

  # Total de Manifestações finalizadas fora do prazo SEM REABERTURAS
  def ticket_replied_expired
    replied_and_expired_scope(not_reopened_scope(within_confirmed_at(answer_scope)))
  end

  # Total de Manifestações finalizadas fora do prazo COM REABERTURAS
  def reopen_replied_expired
    join_ticket_log_reopen_and_answer(
      replied_and_expired_scope(answer_reopened_scope(answer_scope))
    )
  end

  private

  def date_range
    start_date..end_date
  end

  def reopened_scope(tickets)
    tickets.joins(:ticket_logs)
      .where(ticket_logs: { action: [:pseudo_reopen, :reopen], created_at: date_range })
  end

  def within_confirmed_at(tickets)
    tickets.where(confirmed_at: date_range)
  end

  def calculate_solvability
    count = total_count - confirmed_and_not_expired_count
    return 0.0 if count == 0
    (replied_and_not_expired_count * 100.0) / count
  end

  def replied_and_expired_scope(scope)
    replied_scope(scope).where('answers.deadline < 0')
  end

  def replied_and_not_expired_scope(scope)
    replied_scope(scope).where('answers.deadline >= 0')
  end
end
