module Reports::Tickets::ScopePresenter

  def replied_scope(scope)
		scope
			.where(answers: { status: Answer::VISIBLE_TO_USER_STATUSES })
			.where.not(answers: { answer_scope: Answer::POSITIONING_SCOPES })
  end

  def join_ticket_log_reopen_and_answer(scope)
    scope.where(<<-SQL)
      (
        ticket_logs.data LIKE ('%count: ' || answers.version  || E'\n%') OR
        ticket_logs.data LIKE ('%count: ' || answers.version || ',%')
      )
    SQL
  end

  def replied_and_expired_scope(scope)
    replied_scope(scope).where('answers.sectoral_deadline < 0')
  end

  def replied_and_not_expired_scope(scope)
    replied_scope(scope).where('answers.sectoral_deadline >= 0')
  end

  # Total de Manifestações pendentes fora do prazo
  def expired_scope(scope)
    scope.where('tickets.deadline < 0')
  end

  # Total de Manifestações pendentes no prazo
  def not_expired_scope(scope)
    scope.where('tickets.deadline >= 0')
  end

  def answer_reopened_scope(tickets)
    tickets.joins(:ticket_logs)
    .where(ticket_logs: { action: [:pseudo_reopen, :reopen], created_at: date_range })
    .where('answers.version > 0')
  end

  def not_reopened_scope(tickets)
    tickets.where("answers.version = 0 OR answers.version IS NULL")
  end
end

