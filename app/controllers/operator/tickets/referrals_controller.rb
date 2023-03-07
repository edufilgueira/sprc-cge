class Operator::Tickets::ReferralsController < OperatorController
  include Operator::Tickets::Referrals::Breadcrumbs


  PERMITTED_PARAMS = [
    ticket_departments_attributes: [
      :id,
      :department_id,
      :description,
      :deadline,
      :deadline_ends_at,
      :considerations,
      :user_id,
      protected_attachment_ids: [],
      ticket_department_sub_departments_attributes: [
        :id,
        :sub_department_id,
        :_destroy
      ],
      ticket_department_emails_attributes: [
        :id,
        :email
      ]
    ]
  ]

  helper_method [:ticket]

  # Callbacks

  before_action :can_share_internal_area
  before_action :set_deadline, only: :create
  after_action :update_internal_status, only: :destroy

  # Actions

  def create
    ticket.internal_status = :internal_attendance
    
    if resource_params.present? && ticket.update_attributes(resource_params)
      register_log_for_edit_ticket_description

      redirect_log_and_notify
    else
      flash.now[:alert] = t('.fail')
      render :new
    end
  end

  # Helper methods

  def ticket
    @ticket ||= Ticket.find(params[:ticket_id])
  end

  # privates

  private

  def resource_destroy
    ticket_department = TicketDepartment.find(params[:id])
    ticket_department_id = ticket_department.id
    ticket_forward = ticket_department.ticket
    department_title = ticket_department.title

    notify_and_log_destroy(ticket_department_id, ticket_forward, department_title) if ticket_department.destroy
  end

  def notify_and_log_destroy(ticket_department_id, ticket_forward, department_title)
    Notifier::Referral::Delete.delay.call(ticket_department_id, current_user.id)

    ticket_log_destroy(ticket_forward, department_title)
  end

  def ticket_log_destroy(ticket_forward, department_title)
    data = {
      department: department_title
    }

    RegisterTicketLog.call(ticket_forward, current_user, :delete_forward, { data: data })
    RegisterTicketLog.call(ticket_forward.parent, current_user, :delete_forward, { data: data })
  end

  def redirect_to_index_with_success
    flash[:notice] = t('.destroy.done')
    redirect_to_referral
  end

  def redirect_to_index_with_error
    flash[:notice] = t('.destroy.fail')
    redirect_to_referral
  end

  def redirect_to_referral
    redirect_to new_operator_ticket_referral_path(ticket)
  end

  def resource_params
    params_ticket[:ticket_departments_attributes].keys.each do |index|
      params_ticket[:ticket_departments_attributes][index][:user_id] = current_user.id
    end

    if params_ticket.present?
      params.require(:ticket).permit(PERMITTED_PARAMS)
    end
  end

  def ticket_department_attributes
    resource_params[:ticket_departments_attributes]
  end

  def register_log
    ticket_department_attributes.each { |_, v| save_forward_log(v) }
  end

  def save_forward_log(new_record)
    return if new_record[:id].present?

    department = department_from_new_record(new_record)

    ticket_department = ticket_department(department.id)

    RegisterTicketLog.call(ticket, current_user, :forward, { resource: department, data: data_attributes(ticket_department) })
    RegisterTicketLog.call(ticket.parent, current_user, :forward, { resource: department, data: data_attributes(ticket_department) })
  end

  def data_attributes(ticket_department)
    {
      emails: ticket_department.ticket_department_emails.map(&:email),
      considerations: ticket_department.considerations
    }
  end

  def department_from_new_record(new_record)
    department_id = new_record['department_id']

    Department.find(department_id)
  end

  def notify
    ticket_department_attributes.each do |_, v|
      next if v[:id].present?

      department_id = v[:department_id].to_i if v[:department_id].present?

      Notifier::Referral.delay.call(ticket.id, department_id, current_user.id)

      notify_additional_users(department_id)
    end
  end

  def notify_additional_users(department_id)
    ticket_department = ticket_department(department_id)
    return unless ticket_department.present?

    ticket_department.ticket_department_emails.each do |ticket_department_email|
      Notifier::Referral::AdditionalUser.delay.call(ticket.id, ticket_department_email.id, current_user.id)
    end
  end

  def ticket_department(department_id)
    ticket.ticket_departments.find_by(department_id: department_id)
  end

  def can_share_internal_area
    authorize!(:share_internal_area, ticket)
  end

  def set_deadline
    ticket_departments_values.each do |ticket_department|
      next if ticket_department[:id].present?

      deadline_ends_at = ticket_department_deadline_date(ticket_department)

      next if deadline_ends_at.blank?

      ticket_department[:deadline] = calculate_deadline(deadline_ends_at)
      ticket_department[:deadline_ends_at] = deadline_ends_at
    end
  end

  def calculate_deadline(deadline_ends_at)
    (deadline_ends_at - Date.today).to_i
  end

  def ticket_department_deadline_date(ticket_department)
    if current_user.internal?
      current_internal_deadline
    else
      ticket_department[:deadline_ends_at]&.to_date
    end
  end

  def current_internal_deadline
    ticket_department_by_user.deadline_ends_at
  end

  def ticket_department_by_user
    ticket.ticket_department_by_user(current_user)
  end

  def ticket_departments_values
    (params_ticket.present? && params_ticket[:ticket_departments_attributes].values) || []
  end

  def redirect_log_and_notify
    register_log && notify
    redirect_to operator_ticket_path(ticket, anchor: 'tabs-areas'), notice: t('.done')
  end

  def params_ticket
    params[:ticket]
  end

  def update_internal_status
    ticket.sectoral_attendance! if ticket.internal_attendance? && ticket.ticket_departments.empty?
  end

  # Registra no log a ação quando a manifestação for do tipo denuncia e a descrição for
  # alterada, no ato do encaminhamento do Ouvidor para a Área Interna.
  def register_log_for_edit_ticket_description
    if ticket.denunciation? && (ticket.denunciation_description != ticket_department_description)
      RegisterTicketLog.call(ticket.parent, current_user, :edit_ticket_description)
    end
  end

  def ticket_department_description
    params_ticket[:ticket_departments_attributes].values.last['description']
  end

end
