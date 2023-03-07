class Operator::Tickets::EmailRepliesController < OperatorController
  include Operator::Tickets::EmailReplies::Breadcrumbs

  before_action :can_email_reply

  helper_method [:ticket]

  PERMITTED_PARAMS = [
    :email
  ]

  def update
    if valid_email?
      update_tickets
      send_email && redirect_to_show_with_success
    else
      render_to_edit_with_error
    end
  end

  def ticket
    resource
  end

  def resource
    @resource ||= Ticket.find(params[:ticket_id])
  end


  # privates

  private

  def resource_params
    if params[:ticket].present?
      params.require(:ticket).permit(PERMITTED_PARAMS)
    end
  end

  def resource_klass
    Ticket
  end

  def ticket_parent
    ticket.parent || ticket
  end

  def children
    ticket_parent.tickets
  end

  def update_tickets
    ticket_parent.update_attributes(resource_params)

    children.map { |ticket| ticket.update_attributes(resource_params) } if children.present?
  end

  def can_email_reply
    authorize! :email_reply, ticket
  end

  def send_email
    Ticket::EmailReply.delay.call(ticket.id)
  end

  def valid_email?
    email = resource_params[:email]

    User::REGEX_EMAIL_FORMAT.match(email).present?
  end

  def redirect_to_show_with_success
    set_success_flash_notice

    return redirect_to operator_call_center_ticket_path(id: ticket) if comes_from_call_center?

    redirect_to operator_ticket_path(ticket)
  end

  def comes_from_call_center?
    request.referrer.to_s.include?('call_center_tickets')
  end

  def set_success_flash_notice
    flash[:notice] = t('.done', email: resource_params[:email], protocol: ticket.parent_protocol)
  end

  def render_to_edit_with_error
    ticket.errors.add(:email, :not_valid, message: t('.errors.email'))
    flash[:alert] = t('.fail')
    render :edit
  end

end
