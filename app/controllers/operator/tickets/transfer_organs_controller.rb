class Operator::Tickets::TransferOrgansController < OperatorController
  include Operator::Tickets::TransferOrgans::Breadcrumbs
  include ::Tickets::Transfers::BaseController

  PERMITTED_PARAMS = [
    :rede_ouvir,
    :organ_id,
    :subnet_id,
    :unknown_subnet,
    :justification
  ]

  before_action :force_ticket_to_confirmed, :can_transfer_ticket

  helper_method [:ticket, :justification]

  def create
    ActiveRecord::Base.transaction do
      ticket_default_attributes
      clear_ticket_classification

      if ticket.update_attributes(permitted_params)
        redirect_log_and_notify
      else
        set_error
        render :new
        raise ActiveRecord::Rollback
      end
    end
  end

  # Helper methods

  def ticket
    @ticket ||= Ticket.find(params[:ticket_id])
  end

  def justification
    ticket.justification
  end

  # Private

  private

  def ticket_default_attributes
    ticket.internal_status = :sectoral_attendance

    if params[:ticket][:subnet_id].present?
      # Força o 'Não sei a sub-rede' para falso no caso de transferência para uma sub-rede
      ticket.internal_status = :subnet_attendance
    else
      # Força limpar o campo subrede caso a transferência seja apenas para um órgão
      ticket.subnet_id = nil
    end
  end

  def permitted_params
    if params[:ticket]
      params.require(:ticket).permit(PERMITTED_PARAMS)
    end
  end

  def transferred_resource
    ticket.subnet || ticket.organ
  end

  def register_log
    RegisterTicketLog.call(ticket.parent, current_user, :transfer, { description: justification, resource: transferred_resource })
  end

  def notify
    Notifier::Transfer.delay.call(ticket.id, current_user.id)
  end

  def can_transfer_ticket
    authorize! :transfer_organ, ticket
  end

  def force_ticket_to_confirmed
    return unless ticket.in_progress?
    ticket.status = :confirmed
    ticket.confirmed_at = DateTime.now
  end

  def redirect_log_and_notify
    register_log_and_redirect_to_index && notify
  end

  def clear_ticket_classification
    ActiveRecord::Base.transaction do
      return unless ticket.classified?

      ticket.classification.destroy
      ticket.update_attributes(classified: false)
    end 
  end
end
