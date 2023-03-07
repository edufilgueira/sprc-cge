module Operator::Reports::FiltersBase

  private

  def filtered_by_expireds(scope)
    return scope unless expired
    scope.where("tickets.deadline < 0")
  end

  def filtered_by_budget_program(scope)
    return scope unless params[:budget_program].present?
    scope.left_joins(:classification).where(classifications: { budget_program: params[:budget_program] })
  end

  def filtered_by_topic(scope)
    return scope unless params[:topic].present?
    scope.left_joins(:classification).where(classifications: { topic: params[:topic] })
  end

  def filtered_by_subtopic(scope)
    return scope unless params[:subtopic].present?
    scope.left_joins(:classification).where(classifications: { subtopic: params[:subtopic] })
  end

  def filtered_by_priority(scope)
    return scope unless priority
    scope.where(priority: priority)
  end

  def filtered_by_finalized(scope)
    return scope if params[:finalized].present? || params[:internal_status].present?
    scope.active
  end

  def filtered_by_deadline(scope)
    return scope unless params[:deadline].present?
    scope.with_deadline(params[:deadline])
  end

  def filtered_by_internal_status(scope)
    return scope unless params[:internal_status].present?
    scope.with_internal_status(params[:internal_status])
  end

  def filtered_by_denunciation(scope)
    return scope unless params[:denunciation].present?
    scope.denunciation
  end

  def expired
    @expired ||= ActiveModel::Type::Boolean.new.cast(params['expired'])
  end

  def priority
    @priority ||= ActiveModel::Type::Boolean.new.cast(params['priority'])
  end

  def filtered_by_sou_type(scope)
    return scope unless params[:sou_type].present?
    scope.with_sou_type(params[:sou_type])
  end

  def filtered_by_state(scope)
    return scope unless params[:state].present?
    scope.left_joins(:city).where(cities: { state: params[:state] })
  end

  def filtered_by_city(scope)
    return scope unless params[:city].present?
    scope.where(city: params[:city])
  end

  def filtered_by_used_input(scope)
    return scope unless params[:used_input].present?
    scope.with_used_input(params[:used_input])
  end

  def filtered_by_answer_type(scope)
    return scope unless params[:answer_type].present?
    scope.with_answer_type(params[:answer_type])
  end

  def filtered_by_other_organs(scope)
    return scope unless params[:other_organs].present?
    scope.left_joins(:classification).where(classifications: { other_organs: true })
  end

  def filter_by_child_organ(tickets)
    return tickets.where(subnet_id: params[:subnet]) if params[:subnet].present?

    return tickets.without_organ_dpge unless params[:organ].present?
    tickets.where(organ_id: params[:organ])
  end

  def filtered_by_rede_ouvir_scope(scope)
    return scope.where(rede_ouvir: false) unless params[:rede_ouvir_scope].present?
    scope.where(rede_ouvir: true)
  end

  def filter_by_date_range(scope)
    return scope unless params[:confirmed_at].present?

    scope.where(confirmed_at: date_range(params[:confirmed_at])).or(
      scope.where(id: reopened_tickets(scope))
    )
  end

  def reopened_tickets(scope)
    scope.joins(:ticket_logs).where(ticket_logs: {
      action: [:pseudo_reopen, :reopen],
      created_at: date_range(params[:confirmed_at])
    })
  end
end
