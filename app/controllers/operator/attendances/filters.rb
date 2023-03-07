module Operator::Attendances::Filters

  FILTERED_COLUMNS = [
    :service_type
  ]

  FILTERED_ASSOCIATIONS = [
    { tickets: :ticket_type },
    { tickets: :internal_status },
    { tickets: :call_center_responsible_id },
    :created_by_id,
    { tickets: :answer_type }
  ]

  private

  def filtered_resources
    return Attendance.where(protocol: params[:parent_protocol]) if params[:parent_protocol].present?

    filtered = filter_by_child_organ(sorted_resources)
    filtered = filter_by_deadline(filtered)
    filtered = filter_by_sou_type(filtered)
    filtered = filtered_attendance_by_created_at(filtered)

    filtered(Attendance, filtered)
  end

  def filter_by_child_organ(attendances)
    return attendances unless params[:organ_id].present?
    attendances.joins(ticket: :tickets).where(tickets_tickets: { organ_id: params[:organ_id] })
  end

  def filter_by_deadline(attendances)
    return attendances unless params[:deadline].present?

    scope = attendances.joins(:ticket).where(tickets: { deadline: Ticket::FILTER_DEADLINE[params[:deadline].to_sym] })

    filter_by_extended(scope)
  end

  def filter_by_extended(attendances)
    return attendances unless params[:deadline] =~ /^expired/

    extended = params[:deadline].to_sym == :expired

    attendances.where(tickets: { extended: extended })
  end

  def filter_by_sou_type(attendances)
    return attendances unless params[:sou_type].present?
    attendances.joins(:ticket).where(tickets: { sou_type: params[:sou_type] })
  end

  def filtered_attendance_by_created_at(scope)
    return scope unless params[:created_at].present?
    scope.where(created_at: start_date_filter..end_date_filter)
  end

  def start_date_filter
    return Date.new(0) unless params[:created_at][:start].present?

    Date.parse(params[:created_at][:start])
  end

  def end_date_filter
    return Float::INFINITY unless params[:created_at][:end].present?

    Date.parse(params[:created_at][:end]).end_of_day
  end
end
