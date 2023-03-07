class Operator::Tickets::ChangeAnswerCertificatesController < Operator::BaseCrudController
  include Operator::Tickets::ChangeAnswerCertificates::Breadcrumbs

  PERMITTED_PARAMS = [
    :certificate
  ]

  helper_method [ :answer, :ticket ]

  before_action :can_change_answer_certificate

  def update
    if answer.update_attributes(resource_params)
      register_logs
      redirect_after_save_with_success
    else
      set_error_flash_now_alert
      render :edit
    end
  end

  private

  # Helper methods

  def answer
    resource
  end

  def ticket
    @ticket ||= Ticket.find(params[:ticket_id])
  end

  def resources
    @resources ||= ticket.answers
  end

  def resource_name
    'answer'
  end

  def register_logs
    register_log(ticket)
    register_log(ticket.parent) if ticket.child?
  end

  def register_log(ticket)
    RegisterTicketLog.call(ticket, current_user, :change_answer_certificate, { resource: answer })
  end

  def redirect_after_save_with_success
    set_success_flash_notice
    redirect_to_ticket
  end

  def redirect_to_ticket
    redirect_to operator_ticket_path(ticket)
  end

  def can_change_answer_certificate
    authorize! :change_answer_certificate, answer
  end
end
