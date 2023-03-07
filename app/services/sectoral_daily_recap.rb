class SectoralDailyRecap < BaseDailyRecap

  def self.call
    new.call
  end

  def call
    organs.each do |organ|
      @organ = organ

      users = users_by_organ
      next unless users.present?

      TicketMailer.sectoral_daily_recap(users, recap).deliver
    end
  end

  private

  def users_by_organ
    User.enabled.where(organ_id: @organ, operator_type: operator_types)
  end

  def organs
    ExecutiveOrgan.enabled
  end

  def tickets
    Ticket.where(organ_id: @organ)
      .where(confirmed_at: starts_at..ends_at)
      .without_internal_status(Ticket::INVALIDATED_STATUSES)
  end

  def recap
    {
      range: recap_range,
      organ: @organ.title,
      sou: recap_ticket(sou_scope),
      sic: recap_ticket(sic_scope)
    }
  end

  def ends_at
    @ends_at ||= Date.yesterday.end_of_day
  end


  def starts_at
    @starts_at ||= ends_at.year == 2018 ? '18/07/2018'.to_datetime : ends_at.beginning_of_year
  end

  def recap_range
    {
      starts_at: I18n.l(starts_at, format: :date),
      ends_at: I18n.l(ends_at, format: :date)
    }
  end

  def recap_ticket(scope)
    {
      total: total_count(scope),
      replied: replied_count(scope),
      confirmed: recap_confirmed(scope),
      solvability: solvability(scope),
      answer_time_average: answer_time_average(scope),
      answer_satisfaction_rate: answer_satisfaction_rate(scope)
    }
  end

  def recap_confirmed(scope)
    confirmed = confirmed_scope(scope)
    {
      not_expired: confirmed_not_expired_count(confirmed),
      expired_can_extend: confirmed_expired_can_extend_count(confirmed),
      not_expired_extended: confirmed_not_expired_extended_count(confirmed),
      expired: confirmed_expired_count(confirmed)
    }
  end

  def sou_scope
    tickets.sou
  end

  def sic_scope
    csai_only(tickets.sic)
  end

  # CSAI
  # - com órgão
  # - com pai sem atendimento
  # - com pai com atendimento que seja :sic_forward
  def csai_only(scope)
    scope.left_joins(parent: :attendance)
      .where('attendances.id IS NULL OR attendances.service_type = ?', Attendance.service_types[:sic_forward])
  end

  def total_count(scope)
    scope.count
  end

  def replied_count(scope)
    replied_scope(scope).count
  end

  def confirmed_not_expired_count(scope)
    not_expired_scope(scope).where(extended: false).count
  end

  def confirmed_expired_can_extend_count(scope)
    expired_scope(scope).where(%q{now() - tickets.confirmed_at <= interval '30 days'}).count
  end

  def confirmed_not_expired_extended_count(scope)
    not_expired_scope(scope).where(extended: true).count
  end

  def confirmed_expired_count(scope)
    expired_scope(scope).where(%q{now() - tickets.confirmed_at > interval '30 days'}).count
  end

  def solvability(scope)
    solvability = Ticket::Solvability::SectoralService.call(scope, @organ) || 0.0
    solvability.round 2
  end

  def answer_time_average(scope)
    replied = replied_scope(scope)
    return t('answers.empty') if replied.blank?

    average = replied.sum("DATE_PART('day', tickets.responded_at - tickets.confirmed_at)").to_f / replied.count
    average.round 2
  end

  def answer_satisfaction_rate(scope)
    evaluated = replied_scope(scope).joins(answers: :evaluation)
    return t('evaluations.empty') if evaluated.blank?
    rate = evaluated.sum('evaluations.average').to_f / evaluated.count
    rate.round 2
  end

  def replied_scope(scope)
    scope.with_internal_status(ticket_replied_statuses)
  end

  def confirmed_scope(scope)
    scope.active.without_internal_status(:partial_answer)
  end

  def expired_scope(scope)
    scope.where('tickets.deadline < 0')
  end

  def not_expired_scope(scope)
    scope.where('tickets.deadline >= 0')
  end

  def answered_on_time_scope(scope)
    scope = replied_scope(scope)
    not_expired_scope(scope)
  end

  def ticket_replied_statuses
    [
      Ticket.internal_statuses[:partial_answer],
      Ticket.internal_statuses[:final_answer],
    ]
  end

  def t(key)
    I18n.t(key, scope: 'services.sectoral_daily_recap')
  end

  def operator_types
    [:chief, :sou_sectoral, :sic_sectoral]
  end

end
