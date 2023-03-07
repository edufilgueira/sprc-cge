class Operator::TicketDepartmentsController < OperatorController

  load_and_authorize_resource

  FIND_ACTIONS += ['poke', 'renew_referral']

  PERMITTED_PARAMS = [
    :deadline_ends_at
  ]

  helper_method [:ticket_department]

  # Actions

  def update
    set_deadline

    super
  end

  def poke
    Notifier::TicketDepartment::Poke.delay.call(ticket_department.id, current_user.id)

    success_redirect_to_ticket
  end

  def renew_referral
    ticket.internal_attendance!
    ticket_department.not_answered!
    ticket_department.ticket_department_emails.update_all(active: true)

    notify_renew

    success_redirect_to_ticket
  end

  private

  def success_redirect_to_ticket
    flash[:notice] = t('.done', acronym: ticket_department.department_acronym)
    redirect_to operator_ticket_path(ticket)
  end

  def ticket_department
    resource
  end

  def set_deadline
    ticket_department.deadline = calculate_deadline
  end

  def calculate_deadline
    (deadline_ends_at - Date.today).to_i
  end

  def deadline_ends_at
    resource_params[:deadline_ends_at].to_date
  end

  def ticket
    @ticket ||= ticket_department.ticket
  end

  def ticket_parent
    ticket.parent || ticket
  end

  def redirect_to_show_with_success
    # sobrescrevendo pois não temos show neste controller
    # e devemos redirecionar para o show do ticket
    flash[:notice] = t('.done')

    redirect_to operator_ticket_path(ticket, anchor: 'tabs-areas')

    register_log && notify
  end

  def data_log_attributes
    {
      deadline_ends_at: deadline_ends_at,
      department_acronym: ticket_department.department_acronym,
      organ_acronym: ticket.subnet_acronym || ticket.organ_acronym || ExecutiveOrgan.comptroller.acronym
    }
  end

  def register_log
    RegisterTicketLog.call(ticket_parent, current_user, :edit_department_deadline, { resource: ticket_department, data: data_log_attributes })
  end

  def notify
    Notifier::ExtensionTicketDepartment.delay.call(ticket_department.id, current_user.id)
  end

  def notify_renew
    Notifier::Referral.delay.call(ticket.id, ticket_department.department_id, current_user.id)

    ticket_department.ticket_department_emails.each do |ticket_department_email|
      Notifier::Referral::AdditionalUser.delay.call(ticket.id, ticket_department_email.id, current_user.id)
    end
  end
end
