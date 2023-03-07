module Operator::Reports::TicketReports::Filters
  include Operator::Reports::FiltersBase

  FILTERED_ENUMS = [
    :ticket_type
  ]

  private

  def filtered_tickets
    filtered = filter_by_date_range(sorted_tickets)
    filtered = filter_by_child_organ(filtered)
    filtered = filtered_by_expireds(filtered)
    filtered = filtered_by_priority(filtered)
    filtered = filtered_by_deadline(filtered)
    filtered = filtered_by_internal_status(filtered)
    filtered = filtered_by_denunciation(filtered)
    filtered = filtered_by_sou_type(filtered)
    filtered = filtered_by_state(filtered)
    filtered = filtered_by_city(filtered)
    filtered = filtered_by_used_input(filtered)
    filtered = filtered_by_answer_type(filtered)
    filtered = filtered_by_other_organs(filtered)
    filtered = filtered_by_rede_ouvir_scope(filtered)
    filtered = filtered_by_data_scope(filtered)
    filtered = filtered_by_department(filtered)

    unless params[:other_organs].present?
      filtered = filtered_by_budget_program(filtered)
      filtered = filtered_by_topic(filtered)
      filtered = filtered_by_subtopic(filtered)
    end

    filtered(Ticket, filtered)
  end

  def filtered_by_data_scope(scope)
    return scope unless params[:data_scope].present?

    case params[:data_scope].to_sym
    when :sectoral
      scope.where(subnet_id: nil)
    when :subnet
      scope.where.not(subnet_id: nil)
    else
      scope
    end

  end

  def filtered_by_department(scope)
    return scope unless params[:department].present?
    scope.left_joins(:classification).where(classifications: { department: params[:department] })
  end
end
