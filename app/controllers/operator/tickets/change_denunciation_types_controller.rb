class Operator::Tickets::ChangeDenunciationTypesController < OperatorController
  include Operator::Tickets::ChangeDenunciationTypes::Breadcrumbs

  PERMITTED_PARAMS = [ :denunciation_type ]

  helper_method [:ticket]

  before_action :can_change_denunciation_type

  def create
    ticket.assign_attributes(resource_params)

    if ticket.save
      RegisterTicketLog.call(ticket.parent || ticket, current_user, :change_denunciation_type, { data: create_data_log_attributes })
      redirect_to operator_ticket_path(ticket), notice: t('.done')
    else
      flash.now[:alert] = t('.fail')
      render :new
    end
  end

  # Helper methods

  def ticket
    @ticket ||= Ticket.find(params[:ticket_id])
  end

  private

  def resource_name
    'ticket'
  end

  def can_change_denunciation_type
    authorize! :edit_denunciation_type, ticket
  end

  def create_data_log_attributes
    {
      denunciation_type: ticket.denunciation_type,
      responsible_as_author: current_user.as_author
    }
  end
end
