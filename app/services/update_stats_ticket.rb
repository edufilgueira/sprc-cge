class UpdateStatsTicket

  attr_reader :stats_ticket

  def self.call(stats_ticket_id)
    new(stats_ticket_id).call
  end

  def initialize(stats_ticket_id)
    @stats_ticket = Stats::Ticket.find(stats_ticket_id)
    stats_ticket.started!
  end

  def call
    stats_ticket.data = {
      summary: summary,
      summary_csai: summary_csai,
      organs: organs,
      total_sou_types: total_sou_types,
      used_inputs: used_inputs,
      sou_types: sou_types,
      topics: topics,
      departments: departments,
      years: years
    }

    stats_ticket.created!
  end

  private

  def datetime_range
    starts_at.beginning_of_month..ends_at.end_of_month
  end
  def starts_at
    DateTime.new(stats_ticket.year, stats_ticket.month_start, 1)
  end

  def ends_at
    DateTime.new(stats_ticket.year, stats_ticket.month_end, 1)
  end

  def default_scope
    return @default_scope if @default_scope

    scope = {
      ticket_type: stats_ticket.ticket_type,
      rede_ouvir: false
    }
    scope.merge!(organ: stats_ticket.organ) if stats_ticket.organ.present?
    scope.merge!(subnet: stats_ticket.subnet) if stats_ticket.subnet.present?

    @default_scope = Ticket.leaf_tickets

    if ExecutiveOrgan.dpge.present? && stats_ticket.organ.blank?
      @default_scope = @default_scope.where(organ_id: nil).or(
        @default_scope.where.not(organ_id: ExecutiveOrgan.dpge.id))
    end

    @default_scope = filter_by_date_range(@default_scope.where(scope))
  end

  def tickets(scope = default_scope)
    # Scope igual ao Reports::Tickets::Sou::BaseService (Relatórios).
    # XXX Caso houver ajustes aqui, temos que lembrar de mudar em ambos ou extrair para um base genérico
    scope.without_other_organs.without_internal_status(Ticket::INVALIDATED_STATUSES)
  end

  def summary
    {
      other_organs: other_organs(default_scope),
      completed: completed(default_scope),
      partially_completed: partially_completed(default_scope),
      pending: pending(default_scope),
      average_time_answer: average_time_answer(default_scope),
      resolubility: resolubility(default_scope)
    }
  end

  def summary_csai
    {
      other_organs: other_organs(csai_scope),
      completed: completed(csai_scope),
      partially_completed: partially_completed(csai_scope),
      pending: pending(csai_scope),
      average_time_answer: average_time_answer(csai_scope),
      resolubility: resolubility(csai_scope)
    }
  end

  def csai_scope
    @csai_scope ||= default_scope.left_joins(parent: :attendance).
      where(<<-SQL, Attendance.service_types[:sic_forward], Attendance.service_types[:sou_forward])
        attendances.id IS NULL OR attendances.service_type IN (?, ?)
      SQL
  end

  def other_organs(scope)
    count = within_confirmed_at(scope).with_other_organs.without_internal_status(Ticket::INVALIDATED_STATUSES).count

    {
      count: count,
      percentage: percentage(count, total_count(scope))
    }
  end

  def completed(scope)
    count = reopened_in_range(within_confirmed_at(tickets(scope))).final_answer.count + reopened_count(tickets(scope)) + reopened_out_range(within_confirmed_at(tickets(scope))).count

    {
      count: count,
      percentage: percentage(count, total_count(scope))
    }
  end

  def partially_completed(scope)
    count = reopened_in_range(within_confirmed_at(tickets(scope))).partial_answer.count

    {
      count: count,
      percentage: percentage(count, total_count(scope))
    }
  end

  def pending(scope)
    count = reopened_in_range(within_confirmed_at(tickets(scope))).active.not_partial_answer.count

    {
      count: count,
      percentage: percentage(count, total_count(scope))
    }
  end

  def years
    current_year = stats_ticket.year
    last_year = current_year - 1
    {
      current_year => tickets_by_year(current_year),
      last_year => tickets_by_year(last_year)
    }
  end

  def invalid_tickets
    @invalid_tickets ||= within_confirmed_at(default_scope).with_internal_status(Ticket::INVALIDATED_STATUSES)
  end

  def responded_tickets(scope)
    tickets(scope).where.not(responded_at: nil)
  end

  def responded_tickets_on_time
    responded_tickets.where('tickets.deadline >= 0')
  end

  def valid_tickets_by_organ(organ)
    tickets.from_organ(organ)
  end

  def average_time_answer(scope)
    tickets = responded_tickets(scope)
    return 0 if tickets.blank?

    average = tickets.sum { |t| t.average_days_spent_to_answer(datetime_range) } / tickets.count
    average.round(2)
  end

  # busca as reaberturas do ticket por intervalo (filtro)
  def ticket_reopened_by_range(ticket)
    TicketLog.where(ticket_id: ticket.id, action: :reopen, created_at: datetime_range)
  end

  def resolubility(scope)
    tickets_scope = tickets(scope)
    return 0 if tickets_scope.blank?

    Ticket::Solvability::SectoralService.call(tickets_scope, nil, starts_at, ends_at.end_of_month)
  end

  def average_satisfaction
    evaluated = responded_tickets.joins(answers: :evaluation)
    return 0 if evaluated.blank?
    rate = evaluated.sum('evaluations.average').to_f / evaluated.count
    rate.round 2
  end

  def organs
    return {} if organs_scope.blank?
    organs = hash_count_with_percentage(organs_scope)

    organs.keys.each do |organ_id|
      topics = topics_scope_by_organ(organ_id)

      organs[organ_id][:topics_count] = topics.values.sum
      organs[organ_id][:topics] = topics
    end

    organs
  end

  def used_inputs
    used_inputs = tickets.group(:used_input)
    hash_count_with_percentage(hash_with_reopened(used_inputs))
  end

  def sou_types
    sou_types = tickets.group(:sou_type)
    hash_count_with_percentage(hash_with_reopened(sou_types))
  end

  def topics
    topics = tickets.where.not(classifications: { id: nil })
      .group('classifications.topic_id')

    hash_count_with_percentage(hash_with_reopened(topics))
  end

  def departments
    departments = tickets.where.not(classifications: { id: nil })
      .group('classifications.department_id')

    hash_count_with_percentage(hash_with_reopened(departments))
  end

  def total_sou_types
    # count genérico apenas para ter um valor "próximo do real", por isso
    # não foi feito teste já que o mesmo não deve ser utilizado como "final" e/ou
    # "template" para o refactor desse report.
    Ticket.sou_types.keys.inject({}) do |h, type|
      scope = tickets.with_sou_type(type)
      h[type] = within_confirmed_at(scope).count + reopened_count(scope)
      h
    end
  end

  def organs_scope
    return @organs_scope if @organs_scope

    scope = tickets.group(:organ_id).where.not(organ_id: nil)

    @organs_scope = hash_with_reopened(scope)
  end

  def topics_scope_by_organ(organ_id)
    scope =
    tickets.left_joins(classification: :topic)
      .where(organ_id: organ_id)
      .where.not(topics: { id: nil })
      .group(:topic_id)

    hash_with_reopened(scope)
  end

  def hash_count_with_percentage(hash)
    total = hash.values.sum

    hash.map do |k,v|
      {
        k  => {
          count: v,
          percentage: percentage(v, total)
        }
      }
    end.reduce(:merge)
  end

  def percentage(count, total)
    return 0.0 if total == 0
    (count.to_f * 100 / total).round(2)
  end

  def reopened_count(tickets)
    reopened_scope(tickets).count
  end

  def reopened_scope(tickets)
    tickets.joins(:ticket_logs).where(ticket_logs: { action: :reopen, created_at: datetime_range })
  end

  def hash_with_reopened(hash_scope)
    sorted_hash within_confirmed_at(hash_scope).count.merge(reopened_count(hash_scope)) { |_, a, b| a + b }
  end

  def sorted_hash(hash)
    hash.sort_by { |_key, value| value }.reverse.to_h
  end

  def total_count(scope = default_scope)
    within_confirmed_at(scope).count + reopened_count(scope)
  end

  def within_confirmed_at(tickets)
    tickets.where(confirmed_at: datetime_range)
  end

  def filter_by_date_range(scope)
    scope.where(confirmed_at: datetime_range).or(
      scope.where(id: reopened_scope(scope))
    )
  end

  def reopened_out_range(tickets)
    tickets.where('tickets.reopened_at > ?', ends_at)
  end

  def reopened_in_range(tickets)
    tickets.joins(:ticket_logs)
    .where('tickets.reopened_at IS NULL OR ticket_logs.created_at BETWEEN ? AND ?', starts_at.beginning_of_month, ends_at.end_of_month)
  end

  # Year Methods

  def tickets_by_year(year)
    (1..12).map { |month| tickets_by_year_and_month(year, month) }
  end

  def tickets_by_year_and_month(year, month)
    tickets_scope = valid_tickets_for_year

    range = year_month_range(year, month)

    tickets_scope.where(confirmed_at: range).count +
      reopened_scope_by_month_year(tickets_scope, range).count
  end

  def valid_tickets_for_year
    Ticket.where(ticket_type: stats_ticket.ticket_type)
      .leaf_tickets
      .without_internal_status(Ticket::INVALIDATED_STATUSES)
      .without_other_organs
      .without_organ_dpge
  end

  def year_month_range(year, month)
    date = DateTime.new(year, month, 1)
    date.beginning_of_month..date.end_of_month
  end

  def reopened_scope_by_month_year(tickets, range)
    tickets.joins(:ticket_logs).where(ticket_logs: { action: :reopen, created_at: range })
  end
end
