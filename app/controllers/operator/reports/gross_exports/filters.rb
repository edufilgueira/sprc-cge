module Operator::Reports::GrossExports::Filters
  include Operator::Reports::FiltersBase

  FILTERED_ENUMS = [
    :ticket_type,
    :answer_type
  ]

  private

  def filtered_tickets
    scope = sorted_tickets

    return scope.where(parent_protocol: params[:parent_protocol]) if params[:parent_protocol].present?

    filtered = filter_by_date_range(scope)
    filtered = filter_by_child_organ(filtered)
    filtered = filtered_by_topic(filtered)
    filtered = filtered_by_subtopic(filtered)
    filtered = filtered_by_budget_program(filtered)
    filtered = filtered_by_department(filtered)
    filtered = filtered_by_sub_department(filtered)
    filtered = filtered_by_service_type(filtered)
    filtered = filtered_by_deadline(filtered)
    filtered = filtered_by_used_input(filtered)
    filtered = filtered_by_answer_type(filtered)
    filtered = filtered_by_denunciation(filtered)
    filtered = filtered_by_expireds(filtered)
    filtered = filtered_by_priority(filtered)
    filtered = filtered_by_sou_type(filtered)
    filtered = filtered_by_internal_status(filtered)
    filtered = filtered_tickets_by_ticket_departments_deadline(filtered)
    filtered = filtered_by_rede_ouvir_scope(filtered)


    filtered(Ticket, filtered)
  end

  def filter_by_child_organ(tickets)
    return tickets.where(subnet_id: params[:subnet]) if params[:subnet].present?

    return tickets unless params[:organ].present?
    tickets.where(organ_id: params[:organ])
  end

  def filtered_by_department(scope)
    return scope unless params[:department].present?
    scope.left_joins(:classification).where(classifications: { department: params[:department] })
  end

  def filtered_by_sub_department(scope)
    return scope unless params[:sub_department].present?
    scope.left_joins(:classification).where(classifications: { sub_department: params[:sub_department] })
  end

  def filtered_by_service_type(scope)
    return scope unless params[:service_type].present?
    scope.left_joins(:classification).where(classifications: { service_type: params[:service_type] })
  end

  def filtered_tickets_by_ticket_departments_deadline(scope)
    return scope unless params[:departments_deadline].present?
    scope.with_ticket_department_deadline(params[:departments_deadline])
  end
end
