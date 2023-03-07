class Operator::HomeController < OperatorController
  include FilteredController

  helper_method [
    :tickets_deadline_count,
    :tickets_by_internal_status_count,
    :partial_answer_expired_count,
    :departments,
    :tickets_sectoral_priority_count,
    :internal_tickets_without_answer,
    :tickets_extension_in_progress_count,
    :tickets_denunciation_cards_counts,
    :tickets_reopened_count,
    :attendance_responses_by_operator,
    :attendances_count,
    :attendances_by_operator,
    :tickets_rede_ouvir_cge_count,
    :attendances_waiting_confirmation_count,
    :tickets_couvi_by_internal_status_count,
    :tickets_couvi_reopened_count,
    :tickets_couvi_deadline_count
  ]

  FILTERED_DATE_RANGE = [
    :created_at
  ]

  # Public

  ## Helpers

  def tickets_rede_ouvir_cge_count(ticket_type)
    scope(ticket_type).with_rede_ouvir_cge.count
  end

  def tickets_reopened_count(ticket_type, organ_association=nil)
    tickets_reopened(ticket_type, nil, organ_association).count
  end

  def tickets_couvi_reopened_count(ticket_type)
    organ = ExecutiveOrgan::ombudsman_coordination
    only_parents = false

    tickets = tickets_reopened(ticket_type, only_parents).where(organ_id: organ.id)
    tickets.count
  end

  def tickets_couvi_deadline_count(ticket_type, deadline)
    organ = ExecutiveOrgan::ombudsman_coordination
    only_parents = false

    tickets_deadline = tickets_deadline(ticket_type, deadline, only_parents).where(organ_id: organ.id)

    tickets_deadline.count
  end

  def tickets_deadline_count(ticket_type, deadline, organ_association=nil)
    tickets_deadline = tickets_deadline(ticket_type, deadline, nil, organ_association)
    tickets_deadline.count
  end

  def tickets_by_internal_status_count(ticket_type, internal_status, organ_association=nil)
    tickets = tickets_by_internal_status(ticket_type, internal_status, nil, organ_association)
    tickets.count
  end

  def partial_answer_expired_count(ticket_type, internal_status, organ_association=nil)
    tickets = partial_answer_expire(ticket_type, internal_status, organ_association)
    tickets.count
  end

  def tickets_couvi_by_internal_status_count(ticket_type, internal_status)
    organ = ExecutiveOrgan::ombudsman_coordination
    only_parents = false

    tickets = tickets_by_internal_status(ticket_type, internal_status, only_parents).where(organ_id: organ.id)
    tickets.count
  end

  def tickets_sectoral_priority_count(ticket_type, organ_association=nil)
    scope(ticket_type, nil, organ_association).priority.count
  end

  def tickets_extension_in_progress_count(ticket_type, solicitation=1, status=:in_progress, organ_association=nil)
    scope(ticket_type, nil, organ_association).joins(:extensions).where(
      extensions: { status: status, solicitation: solicitation }
    ).count
  end

  def departments
    return Department.none unless current_user.sectoral?

    departments_without_answer
  end

  def internal_tickets_without_answer(department)
    tickets = scope.internal_attendance

    tickets.joins(:ticket_departments).where(ticket_departments: { answer: :not_answered, department_id: department.id })
  end

  ###
  ### Contadores de denúncias
  ###
  def tickets_denunciation_cards_counts
    {
      cosco_sectoral_attendance: tickets_denunciation_cosco_sectoral_attendance,
      cge_validation: tickets_denunciation_cge_validation,
      waiting_referral: tickets_denunciation_waiting_referral,
      awaiting_invalidation: tickets_denunciation_awaiting_invalidation,
      coordination: tickets_denunciation_coordination
    }
  end

  def tickets_denunciation_cosco_sectoral_attendance
    #
    # EM ATENDIMENTO SETORIAL que estão na COSCO
    #
    {
      count: cosco_sectoral_attendance.count,
      params: operator_tickets_path(ticket_type: :sou, internal_status: :sectoral_attendance, organ: cosco_id, denunciation: 1)
    }
  end

  def tickets_denunciation_cge_validation
    #
    # CGE_VALIDATION
    #
    {
      count: active_denunciation_scope.cge_validation.count,
      params: operator_tickets_path(ticket_type: :sou, internal_status: :cge_validation, denunciation: 1)
    }
  end

  def tickets_denunciation_waiting_referral
    #
    # WAITING_REFERRALS
    #
    {
      count: active_denunciation_scope.waiting_referral.count,
      params: operator_tickets_path(ticket_type: :sou, internal_status: :waiting_referral, denunciation: 1)
    }
  end

  def tickets_denunciation_awaiting_invalidation
    #
    # AWAITING_INVALIDATION
    #
    {
      count: all_with_internal_status(:awaiting_invalidation, active_denunciation_scope).count,
      params: operator_tickets_path(ticket_type: :sou, internal_status: :awaiting_invalidation, denunciation: 1)
    }
  end

  def tickets_denunciation_coordination
    #
    # EM ATENDIMENTO que estão na COORDENAÇÃO DE OUVIDORIA
    #
    {
      count: coordination.count,
      params: operator_tickets_path(ticket_type: :sou, internal_status: :sectoral_attendance, organ: coordination_id, denunciation: 1)
   }
  end

  ###
  ### Contadores de atendimento 155 e supervisor 155
  ###

  def attendances_count(scope)
    attendances.where(scope).count
  end

  def attendances_waiting_confirmation_count
    Ticket.where(tickets: { internal_status: :waiting_confirmation }).count
  end

  def attendances_by_operator
    ids = attendances.group(:created_by_id).order('COUNT(attendances.id) DESC').pluck(:created_by_id)

    ids.map do |id|
      [User.find(id).title, attendances.where(created_by_id: id).count]
    end
  end

  def attendance_responses_by_operator
    ids = attendance_responses_logs.group(:responsible_id).order('COUNT(ticket_logs.id) DESC').pluck(:responsible_id)

    ids.map do |id|
      [User.find(id).title, attendance_responses_logs.where(responsible_id: id).count]
    end
  end

  def redirect_to_ticket_by_protocol
    ticket =
      if current_user.operator_type.to_sym.in? User::OPERATOR_TYPES_FOR_SOU_OPERATORS
        parent_ticket = Ticket.find_by(protocol: params[:protocol])
        parent_ticket.tickets.find_by(organ_id: current_user.organ_id)
      elsif current_user.operator_type.to_sym.in? User::OPERATOR_TYPES_FOR_SECURITY_ORGANS
        parent_ticket = Ticket.find_by(protocol: params[:protocol])
        parent_ticket.tickets.from_security_organ
          .find_by(organs: { acronym: Organ::SECURITY_ORGANS }) if parent_ticket.present?
      else
        Ticket.find_by(protocol: params[:protocol])
      end

    if ticket.present?

      redirect_to operator_ticket_path(ticket)

    else

      flash[:alert] = t('messages.filters.no_results_found')

      redirect_to :back
    end
  end



  # privates

  private

  def tickets_deadline(ticket_type, deadline, only_parents=nil, organ_association=nil)
    only_parents = current_user.coordination? if only_parents.nil?

    tickets_deadline = scope(ticket_type, only_parents, organ_association)
    tickets_deadline = tickets_deadline.where.not(internal_status: [:partial_answer,:appeal])
    tickets_deadline = tickets_deadline.send(ticket_deadline_method, deadline)
  end

  def tickets_reopened(ticket_type, only_parents=nil, tickets_reopened=nil)
    only_parents = current_user.coordination? if only_parents.nil?

    scope(ticket_type, only_parents, tickets_reopened).from_reopened
  end

  def tickets_by_internal_status(ticket_type, internal_status, only_parents=nil, organ_association=nil)
    
    only_parents = current_user.coordination? if only_parents.nil?

    tickets = scope(ticket_type, only_parents, organ_association)
    tickets = all_with_internal_status(internal_status, tickets)

  end

  def partial_answer_expire(ticket_type, internal_status, organ_association=nil)

    if current_user.operator_denunciation? || current_user.cge?
      tickets = partial_answer_expire_scope(ticket_type)
    else
      tickets = scope(ticket_type, nil, organ_association)
    end

    tickets = all_with_internal_status(internal_status, tickets, true)
  end

  def partial_answer_expire_scope(ticket_type)
    den = current_user.operator_denunciation?
    den ? Ticket.from_type(ticket_type).active : Ticket.from_type(ticket_type).active.not_denunciation
  end

  def attendances
    @attendances ||= filtered(Attendance, attendances_default_scope)
  end

  def attendance_responses_logs
    @attendance_responses_logs ||= filtered(TicketLog, attendance_response_logs_default_scope)
  end

  def attendance_response_logs_default_scope
    #
    # Ticketlog para conseguirmos recuparar o responsible facilmente
    #
    ticket_logs = TicketLog.attendance_response

    return ticket_logs if params[:created_at].present?

    ticket_logs.where(created_at: Date.today..Date.today.end_of_day)
  end

  def attendances_default_scope
    return Attendance.all if params[:created_at].present?

    Attendance.where(created_at: Date.today..Date.today.end_of_day)
  end

  def scope(ticket_type=nil, only_parents=false, organ_association=nil)
      
    ticket_type ||= accessible_operator_ticket_type

    if only_parents
      operator_tickets(organ_association).from_type(ticket_type).active.parent_tickets
    else
      operator_tickets(organ_association).from_type(ticket_type).active
    end
  end

  def accessible_operator_ticket_type
    current_user.sic_sectoral? ? [:sic] : [:sou, :sic]
  end

  def operator_tickets(organ_association=nil)
    #
    # Escopo padrão para tickets que não são denúncias
    #
    
    if current_user.sectoral_denunciation?
      current_user.operator_accessible_tickets(organ_association)
    else
      current_user.operator_accessible_tickets(organ_association).not_denunciation
    end
  end

  def ticket_deadline_method
    current_user.internal? ? :with_ticket_department_deadline : :with_deadline
  end

  def departments_without_answer
    joins_departments_tickets
      .where(ticket_departments: { answer: :not_answered },
        tickets: {
          internal_status: :internal_attendance, ticket_type: accessible_operator_ticket_type
        })
    .distinct
  end

  def joins_departments_tickets
    sectoral_departments.joins(ticket_departments: :ticket)
  end

  def sectoral_organ
    current_user.organ
  end

  def sectoral_departments
    sectoral_organ.departments
  end

  def active_denunciation_scope
    current_user.operator_accessible_tickets.denunciation.parent_tickets.active
  end

  def cosco_id
    @cosco_id ||= ExecutiveOrgan.denunciation_commission.id
  end

  def coordination_id
    @coordination_id ||= ExecutiveOrgan.ombudsman_coordination.id
  end

  def cosco_sectoral_attendance
    active_denunciation_scope.left_joins(:tickets).where(internal_status: :sectoral_attendance, tickets_tickets: { organ_id: cosco_id })
  end

  def coordination
     active_denunciation_scope.left_joins(:tickets).where(internal_status: :sectoral_attendance, tickets_tickets: { organ_id: coordination_id })
  end

  def all_with_internal_status(internal_status, tickets, expired = nil)

    return parent_with_children_awaiting_invalidation(tickets) if internal_status == :awaiting_invalidation
    return tickets.with_answers_awaiting_cge_validation if internal_status == :cge_validation
    return tickets.with_internal_status_expired(internal_status, current_user) if !expired.nil?
    
    tickets.with_internal_status(internal_status)

  end

  def parent_with_children_awaiting_invalidation(tickets)
    tickets.left_joins(:tickets).where(tickets_tickets: { internal_status: awaiting_invalidation }).distinct
  end

  def awaiting_invalidation
    Ticket.internal_statuses[:awaiting_invalidation]
  end
end
