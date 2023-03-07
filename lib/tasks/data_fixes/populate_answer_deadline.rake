namespace :data_fixes do
  #
  # A coluna Answers#deadline foi adicionada para suprir a necessidade de saber o
  # prazo em que foi dada cada resposta de uma chamado. Os campos do Ticket mantém
  # informações somente do prazo atual. Caso houver reaberturas, não era possível
  # saber qual foi o prazo das as respostas anteriores.
  #
  # RAILS_ENV=production bundle rake data_fixes:populate_answer_deadline
  task populate_answer_deadline: :environment do
    answers = Answer.joins(:ticket).where(status: Answer::VISIBLE_TO_USER_STATUSES, deadline: nil).where.not(answer_scope: Answer::POSITIONING_SCOPES).sorted

    answers.find_each do |answer|
      ticket = answer.ticket
      ticket_logs_interval = ticket_log_interval(answer)

      ticket_deadline = initial_ticket_date(answer, ticket_logs_interval)
      ticket_deadline += ticket_deadline(ticket.ticket_type, ticket_logs_interval).day

      answer_deadline = answer_deadline_by_version(ticket, answer.version)
      answer_deadline ||= (ticket_deadline.to_date - answer.created_at.to_date).to_i

      answer.update(deadline: answer_deadline, sectoral_deadline: answer_deadline)
    end
  end

  def ticket_log_interval(answer)
    ticket_logs = all_ticket_logs(answer)
    starts_at = ticket_log_interval_starts_at(answer)
    ends_at = ticket_log_interval_ends_at(answer)

    ticket_logs.where(created_at: starts_at..ends_at)
  end

  def ticket_log_interval_starts_at(answer)
    return answer.ticket.confirmed_at unless answer_for_reopen_or_appeal?(answer)

    ticket_logs = all_ticket_logs(answer)
    ticket_logs.where("data LIKE '%count: #{answer.version}%'").first.created_at
  end

  def ticket_log_interval_ends_at(answer)
    ticket_logs = all_ticket_logs(answer)
    ticket_log = ticket_logs.answer.find_by(resource: answer)

    return ticket_log.created_at if ticket_log.present?
    ticket_logs.answer.where(responsible_type: "User").first(answer.version + 1).last.created_at
  end

  def all_ticket_logs(answer)
    ticket = answer.ticket
    parent = ticket.parent || ticket
    ticket_logs = parent.ticket_logs.sorted
  end

  def ticket_deadline(ticket_type, ticket_logs)
    ticket_extended?(ticket_logs) ? Ticket.response_extension(ticket_type) : Ticket.response_deadline(ticket_type)
  end

  def ticket_extended?(ticket_logs)
    ticket_logs.extension.where("data LIKE '%status: approved%'").exists?
  end

  def initial_ticket_date(answer, ticket_logs)
    return answer.ticket.confirmed_at unless answer_for_reopen_or_appeal?(answer)
    ticket_logs.where("data LIKE '%count: #{answer.version}%'").first.created_at
  end

  def answer_for_reopen_or_appeal?(answer)
    answer.version > 0
  end

  def answer_deadline_by_version(ticket, answer_version)
    ticket.answers.where(status: Answer::VISIBLE_TO_USER_STATUSES, version: answer_version).first&.deadline
  end
end
