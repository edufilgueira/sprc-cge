class Platform::Tickets::PublishTicketsController < PlatformController

  helper_method [:ticket]

  # Callbacks

  before_action :can_publish_ticket

  def create
    if params[:public_ticket].present? && update_public_ticket
      set_success_flash_notice
    else
      set_error_flash_alert
    end

    redirect_to platform_ticket_path(ticket)
  end

  # Helper methods

  def ticket
    @ticket ||= Ticket.find(params[:ticket_id])
  end

  private

  def resource_klass
    Ticket
  end

  def param_public_ticket
    @public_ticket ||= ActiveModel::Type::Boolean.new.cast(params['public_ticket'])
  end

  def can_publish_ticket
    authorize! :publish_ticket, ticket
  end

  def update_public_ticket
    ticket.update_attributes(public_ticket: param_public_ticket)
  end


  def set_success_flash_notice
    flash[:notice] = t(".#{ticket.ticket_type}.done.#{param_public_ticket}")
  end

  def set_error_flash_alert
    flash[:alert] = t(".#{ticket.ticket_type}.error.#{param_public_ticket}")
  end
end
