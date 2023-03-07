class Reports::Tickets::Sic::SolvabilityDeadlinePresenter < Reports::Tickets::Sic::BasePresenter

  GROUPS = [:call_center_csai, :call_center, :csai]

  attr_reader :scope, :default_scope

  def initialize(scope, ticket_report)
    @ticket_report = ticket_report
    @scope = scope
    @default_scope = scope.left_joins(parent: :attendance).
      joins(:organ).where.not(responded_at: nil)
    @infos = {
      call_center_csai: [],
      call_center: [],
      csai: []
    }
  end

  def call
    build_infos
    sort_infos
    @infos
  end

  private

  def build_infos
    default_scope.distinct.pluck('organs.acronym', 'organs.id').each do |organ|
      organ_scope = default_scope.where(organ_id: organ[1])

      result = count_deadlines(organ_scope)

      GROUPS.each do |g|
        @infos[g] << [organ[0]] + result[g].values
      end
    end
  end

  def sort_infos
    GROUPS.each do |g|
      @infos[g].sort! { |a, b| a[0] <=> b[0] }
    end
  end

  def count_deadlines(organ_scope)
    count  = default_count

    organ_scope.each do |ticket|
      date = ticket.confirmed_at
      count_ticket(ticket, count, date, 0) if date.between?(beginning_date, end_date)

      count_reopened_deadlines(ticket, count)
    end

    count
  end

  def count_reopened_deadlines(ticket, count)
    filtered_ticket_logs(ticket).each do |ticket_log|
      version = ticket_log.data[:count]

      next unless valid_ticket_log?(ticket, version)

      count_ticket(ticket, count, ticket_log.created_at, version)
    end
  end

  def valid_ticket_log?(ticket, version)
    ticket.final_answer? || ticket.partial_answer? || version < ticket.reopened
  end

  def count_ticket(ticket, count, date, version)
    days = responded_days(ticket, date, version)

    type =  count_type(ticket, days)

    count[:call_center_csai][type] += 1

    if version == 0 && ticket.parent&.attendance_completed?
      count[:call_center][type] += 1
    else
      count[:csai][type] += 1
    end
  end

  def responded_days(ticket, date, version)
    answer = ticket.answers.approved_for_citizen.by_version(version).first

    return 0 unless answer.present?

    (answer.created_at.to_date - date.to_date).to_i
  end

  def filtered_ticket_logs(ticket)
    ticket.ticket_logs.reopen.sorted.where(created_at: date_range)
  end

  def count_type(ticket, days)
    case days
    when 21..30
      if ticket.extended?
        :between_21_30_deadline
      else
        :between_21_30
      end
    when 31..Float::INFINITY
      :more_than_30
    else
      :until_20
    end
  end

  def default_count
    {
      call_center_csai: default_deadlines,
      call_center: default_deadlines,
      csai: default_deadlines
    }
  end

  def default_deadlines
    {
      until_20: 0,
      between_21_30_deadline: 0,
      between_21_30: 0,
      more_than_30: 0
    }
  end
end
