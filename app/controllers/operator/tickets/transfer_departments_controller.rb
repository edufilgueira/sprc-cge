class Operator::Tickets::TransferDepartmentsController < OperatorController
  include Operator::Tickets::TransferDepartments::Breadcrumbs
  include ::Tickets::Transfers::BaseController

  before_action :can_share_internal_area

  PERMITTED_PARAMS = [
    :id,
    :department_id,
    :justification
  ]

  helper_method [:ticket, :ticket_department, :justification]

  def update
    ActiveRecord::Base.transaction do
      if ticket_department.update_attributes(resource_params)
        register_log_and_redirect_to_index && notify
      else
        set_error
        render :edit
      end
    end
  end

  # Helper methods

  def ticket
    @ticket ||= Ticket.find(params[:ticket_id])
  end

  def ticket_department
    @ticket_department ||= ticket.ticket_departments.find(params[:id])
  end

  def justification
    ticket_department.justification
  end

  # Private

  private

  def resource_params
    if params[:ticket_department]
      params.require(:ticket_department).permit(PERMITTED_PARAMS)
    end
  end

  def register_log
    unit = ticket_department.department

    RegisterTicketLog.call(ticket.parent, current_user, :transfer, { description: justification, resource: unit })
  end

  def notify
    Notifier::Transfer.delay.call(ticket.id, current_user.id, ticket_department.id)
  end

  def can_share_internal_area
    authorize!(:transfer_department, ticket_department)
  end
end
